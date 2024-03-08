within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer;
model GroundTemperatureResponse "Model calculating discrete load aggregation"
  parameter Modelica.Units.SI.Time tLoaAgg(final min=Modelica.Constants.eps)=
    3600 "Time resolution of load aggregation";
  parameter Integer nCel(min=1)=5 "Number of cells per aggregation level";
  parameter Integer nSeg=12
    "Number of segments per borehole for g-function calculation";
  parameter Integer nClu=5 "Number of clusters for g-function calculation";
  parameter Boolean forceGFunCalc = false
    "Set to true to force the thermal response to be calculated at the start instead of checking whether it has been pre-computed";
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat
    "Record containing all the parameters of the borefield model" annotation (
     choicesAllMatching=true, Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Modelica.Blocks.Interfaces.RealOutput delTBor(unit="K")
    "Temperature difference current borehole wall temperature minus initial borehole wall temperature"
    annotation (Placement(transformation(extent={{100,-14},{126,12}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput QBor_flow(unit="W")
    "Heat flow from all boreholes combined (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  constant Integer nTimSho = 26 "Number of time steps in short time region";
  constant Integer nTimLon = 50 "Number of time steps in long time region";
  constant Real ttsMax = exp(5) "Maximum non-dimensional time for g-function calculation";
  constant Integer nTimTot = nTimSho+nTimLon
    "Total length of g-function vector";
  constant Real lvlBas = 2 "Base for exponential cell growth between levels";

  parameter String SHAgfun=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction(
      nBor=borFieDat.conDat.nBor,
      cooBor=borFieDat.conDat.cooBor,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      aSoi=borFieDat.soiDat.aSoi,
      nSeg=nSeg,
      nClu=nClu,
      nTimSho=nTimSho,
      nTimLon=nTimLon,
      ttsMax=ttsMax) "String with encrypted g-function arguments";
  parameter Modelica.Units.SI.Time timFin=(borFieDat.conDat.hBor^2/(9*borFieDat.soiDat.aSoi))
      *ttsMax "Final time for g-function calculation";
  parameter Integer i(min=1)=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.countAggregationCells(
      lvlBas=lvlBas,
      nCel=nCel,
      timFin=timFin,
      tLoaAgg=tLoaAgg)
      "Number of aggregation cells";
  final parameter Real[nTimTot,2] timSer(each fixed=false)
    "g-function input from matrix, with the second column as temperature Tstep";
  final parameter Modelica.Units.SI.Time t_start(fixed=false)
    "Simulation start time";
  final parameter Modelica.Units.SI.Time[i] nu(each fixed=false)
    "Time vector for load aggregation";
  final parameter Real[i] kappa(each fixed=false)
    "Weight factor for each aggregation cell";
  final parameter Real[i] rCel(each fixed=false) "Cell widths";

  discrete Modelica.Units.SI.HeatFlowRate[i] QAgg_flow
    "Vector of aggregated loads";
  discrete Modelica.Units.SI.HeatFlowRate[i] QAggShi_flow
    "Shifted vector of aggregated loads";
  discrete Integer curCel "Current occupied cell";

  discrete Modelica.Units.SI.TemperatureDifference delTBor0
    "Previous time step's temperature difference current borehole wall temperature minus initial borehole temperature";
  discrete Real derDelTBor0(unit="K/s")
    "Derivative of wall temperature change from previous time steps";
  final parameter Real dTStepdt(fixed=false)
    "Time derivative of g/(2*pi*H*Nb*ks) within most recent cell";

  Modelica.Units.SI.Heat U "Accumulated heat flow from all boreholes";
  discrete Modelica.Units.SI.Heat U_old
    "Accumulated heat flow from all boreholes at last aggregation step";

initial equation
  QAgg_flow = zeros(i);
  curCel = 1;
  delTBor = 0;
  QAggShi_flow = QAgg_flow;
  delTBor0 = 0;
  U = 0;
  U_old = 0;
  derDelTBor0 = 0;

  (nu,rCel) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.aggregationCellTimes(
    i=i,
    lvlBas=lvlBas,
    nCel=nCel,
    tLoaAgg=tLoaAgg,
    timFin=timFin);

  t_start = time;

  kappa = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.aggregationWeightingFactors(
    i=i,
    nTimTot=nTimTot,
    TStep=timSer,
    nu=nu);

  dTStepdt = kappa[1]/tLoaAgg;

  timSer =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.temperatureResponseMatrix(
      nBor=borFieDat.conDat.nBor,
      cooBor=borFieDat.conDat.cooBor,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      aSoi=borFieDat.soiDat.aSoi,
      kSoi=borFieDat.soiDat.kSoi,
      nSeg=nSeg,
      nClu=nClu,
      nTimSho=nTimSho,
      nTimLon=nTimLon,
      nTimTot=nTimTot,
      ttsMax=ttsMax,
      sha=SHAgfun,
      forceGFunCalc=forceGFunCalc);

equation
  der(delTBor) = dTStepdt*QBor_flow + derDelTBor0;
  der(U) = QBor_flow;

  when sample(t_start, tLoaAgg) then
    // Assign average load since last aggregation step to the first cell of the
    // aggregation vector
    U_old = U;

    // Store (U - pre(U_old))/tLoaAgg in QAgg_flow[1], and pre(QAggShi_flow) in the other elements
    QAgg_flow = cat(1, {(U - pre(U_old))/tLoaAgg}, pre(QAggShi_flow[2:end]));
    // Shift loads in aggregation cells
    (curCel,QAggShi_flow) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.shiftAggregationCells(
      i=i,
      QAgg_flow=QAgg_flow,
      rCel=rCel,
      nu=nu,
      curTim=(time - t_start));

    // Determine the temperature change at the next aggregation step (assuming
    // no loads until then)
    delTBor0 = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.temporalSuperposition(
      i=i,
      QAgg_flow=QAggShi_flow,
      kappa=kappa,
      curCel=curCel);

    derDelTBor0 = (delTBor0-delTBor)/tLoaAgg;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,-4},{72,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-100,30},{-94,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model calculates the ground temperature response to obtain the temperature
at the borehole wall in a geothermal system where heat is being injected into or
extracted from the ground.
</p>
<p>
A load-aggregation scheme based on that developed by Claesson and Javed (2012) is
used to calculate the borehole wall temperature response with the temporal superposition
of ground thermal loads. In its base form, the
load-aggregation scheme uses fixed-length aggregation cells to agglomerate
thermal load history together, with more distant cells (denoted with a higher cell and vector index)
representing more distant thermal history. The more distant the thermal load, the
less impactful it is on the borehole wall temperature change at the current time step.
Each cell has an <em>aggregation time</em> associated to it denoted by <code>nu</code>,
which corresponds to the simulation time (since the beginning of heat injection or
extraction) at which the cell will begin shifting its thermal load to more distant
cells. To determine <code>nu</code>, cells have a temporal size <i>r<sub>cel</sub></i>
(<code>rcel</code> in this model)
which follows the exponential growth
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_02.png\" />
</p>
<p>
where <i>n<sub>Cel</sub></i> is the number of consecutive cells which can have the same size.
Decreasing <i>r<sub>cel</sub></i> will generally decrease calculation times, at the cost of
precision in the temporal superposition. <code>rcel</code> is expressed in multiples
of the aggregation time resolution (via the parameter <code>tLoaAgg</code>).
Then, <code>nu</code> may be expressed as the sum of all <code>rcel</code> values
(multiplied by the aggregation time resolution) up to and including that cell in question.
</p>
<p>
To determine the weighting factors, the borefield's temperature
step response at the borefield wall is determined as
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_03.png\" />
</p>
<p>
where <i>g(&middot;)</i> is the borefield's thermal response factor known as the <em>g-function</em>,
<i>H</i> is the total length of all boreholes and <i>k<sub>s</sub></i> is the thermal
conductivity of the soil. The weighting factors <code>kappa</code> (<i>&kappa;</i> in the equation below)
for a given cell <i>i</i> are then expressed as follows.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_04.png\" />
</p>
<p>
where <i>&nu;</i> refers to the vector <code>nu</code> in this model and
<i>T<sub>step</sub>(&nu;<sub>0</sub>)</i>=0.
</p>
<p>
At every aggregation time step, a time event is generated to perform the load aggregation steps.
First, the thermal load is shifted. When shifting between cells of different size, total
energy is conserved. This operation is illustred in the figure below by Cimmino (2014).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_01.png\" />
</p>
<p>
After the cell-shifting operation is performed, the first aggregation cell has its
value set to the average thermal load since the last aggregation step.
Temporal superposition is then applied by means
of a scalar product between the aggregated thermal loads <code>QAgg_flow</code> and the
weighting factors <i>&kappa;</i>.
</p>
<p>
Due to Modelica's variable time steps, the load aggregation scheme is modified by separating
the thermal response between the current aggregation time step and everything preceding it.
This is done according to
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_05.png\" />
<br/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_06.png\" />
</p>
<p>
where <i>T<sub>b</sub></i> is the borehole wall temperature,
<i>T<sub>g</sub></i>
is the undisturbed ground temperature,
<i>Q</i> is the ground thermal load per borehole length and <i>h = g/(2 &pi; k<sub>s</sub>)</i>
is a temperature response factor based on the g-function. <i>t<sub>k</sub></i>
is the last discrete aggregation time step, meaning that the current time <i>t</i>
satisfies <i>t<sub>k</sub>&le;t&le;t<sub>k+1</sub></i>.
<i>&Delta;t<sub>agg</sub>(=t<sub>k+1</sub>-t<sub>k</sub>)</i> is the
parameter <code>tLoaAgg</code> in the present model.
</p>
<p>
Thus,
<i>&Delta;T<sub>b</sub>*(t)</i>
is the borehole wall temperature change due to the thermal history prior to the current
aggregation step. At every aggregation time step, load aggregation and temporal superposition
are used to calculate its discrete value. Assuming no heat injection or extraction until
<i>t<sub>k+1</sub></i>, this term is assumed to have a linear
time derivative, which is given by the difference between <i>&Delta;T<sub>b</sub>*(t<sub>k+1</sub>)</i>
(the temperature change from load history at the next discrete aggregation time step, which
is constant over the duration of the ongoing aggregation time step) and the total
temperature change at the last aggregation time step, <i>&Delta;T<sub>b</sub>(t)</i>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_09.png\" />
</p>
<p>
The second term <i>&Delta;T<sub>b,q</sub>(t)</i> concerns the ongoing aggregation time step.
To obtain the time derivative of this term, the thermal response factor <i>h</i> is assumed
to vary linearly over the course of an aggregation time step. Therefore, because
the ongoing aggregation time step always concerns the first aggregation cell, its derivative (denoted
by the parameter <code>dTStepdt</code> in this model) can be calculated as
<code>kappa[1]</code>, the first value in the <code>kappa</code> vector,
divided by the aggregation time step <i>&Delta;t</i>.
The derivative of the temperature change at the borehole wall is then expressed
as the multiplication of <code>dTStepdt</code> (which only needs to be
calculated once at the start of the simulation) and the heat flow <i>Q</i> at
the borehole wall.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_10.png\" />
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_11.png\" />
</p>
<p>
With the two terms in the expression of <i>&Delta;T<sub>b</sub>(t)</i> expressed
as time derivatives, <i>&Delta;T<sub>b</sub>(t)</i> can itself also be
expressed as its time derivative and implemented as such directly in the Modelica
equations block with the <code>der()</code> operator.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_07.png\" />
<br/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_08.png\" />
</p>
<p>
This load aggregation scheme is validated in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation.Analytic_20Years\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation.Analytic_20Years</a>.
</p>
<h4>References</h4>
<p>
Cimmino, M. 2014. <i>D&eacute;veloppement et validation exp&eacute;rimentale de facteurs de r&eacute;ponse
thermique pour champs de puits g&eacute;othermiques</i>,
Ph.D. Thesis, &Eacute;cole Polytechnique de Montr&eacute;al.
</p>
<p>
Claesson, J. and Javed, S. 2012. <i>A load-aggregation method to calculate extraction temperatures of borehole heat exchangers</i>. ASHRAE Transactions 118(1): 530-539.
</p>
<p>
Prieto, C. and Cimmino, M. 2021. <i>Thermal interactions in large irregular
fields of geothermal boreholes: the method of equivalent boreholes</i>. Journal
of Building Performance Simulation 14(4): 446-460.
<a href=\"https://doi.org/10.1080/19401493.2021.1968953\">
doi:10.1080/19401493.2021.1968953</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
Updated the function to use the more efficient method of Prieto and Cimmino
(2021).
</li>
<li>
August 30, 2018, by Michael Wetter:<br/>
Refactored model to compute the temperature difference relative to the initial temperature,
because the model is independent of the initial temperature.
</li>
<li>
April 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundTemperatureResponse;
