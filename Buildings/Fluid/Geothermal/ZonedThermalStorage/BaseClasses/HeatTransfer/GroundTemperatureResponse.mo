within Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer;
model GroundTemperatureResponse
  "Model calculating discrete load aggregation"
  parameter Modelica.Units.SI.Time tLoaAgg(final min=Modelica.Constants.eps)=
    3600 "Time resolution of load aggregation";
  parameter Integer nCel(min=1)=5 "Number of cells per aggregation level";
  parameter Integer nSeg(min=1)
    "Number of segments per borehole";
  parameter Buildings.Fluid.Geothermal.ZonedThermalStorage.Data.Borefield.Template borFieDat
    "Record containing all the parameters of the borefield model"
    annotation(choicesAllMatching=true,
        Placement(transformation(extent={{-80,-80},{-60,-60}})));

  // Model inputs and outputs
  Modelica.Blocks.Interfaces.RealOutput[nZon, nSeg] delTBor(
    each final unit="K",
    each displayUnit="degC")
    "Temperature difference current borehole wall temperature minus initial borehole wall temperature"
    annotation (Placement(transformation(extent={{100,-14},{126,12}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput[nZon, nSeg] QBor_flow(each final unit="W")
    "Heat flow from borehole segment (positive if heat from fluid into soil)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  constant Real lvlBas = 2 "Base for exponential cell growth between levels";
  constant Real ttsMax = exp(5) "Maximum non-dimensional time for g-function calculation";
  // Adjust the timFin parameter for simulation that span more than 50 years
  constant Modelica.Units.SI.Time timFin=50.*8760.*3600.
    "Final time for g-function calculation";
  final parameter Integer nSegTot = nZon * nSeg
    "Total number of segments";
  final parameter Integer nZon(min=1) = borFieDat.conDat.nZon
    "Total number of independent borefield zones";
  final parameter Integer i(min=1)=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.countAggregationCells(
      lvlBas=lvlBas,
      nCel=nCel,
      timFin=timFin,
      tLoaAgg=tLoaAgg)
      "Number of aggregation cells";
  final parameter Modelica.Units.SI.Time[i] nu(each fixed=false)
    "Time vector for load aggregation";
  final parameter Modelica.Units.SI.Time t_start(fixed=false)
    "Simulation start time";
  final parameter Real[nSegTot,nSegTot,i] kappa(each fixed=false)
    "Weight factor for each aggregation cell";
  final parameter Real[i] rCel(each fixed=false) "Cell widths";

  discrete Modelica.Units.SI.HeatFlowRate[nSegTot,i] QAgg_flow
    "Vector of aggregated loads";
  discrete Modelica.Units.SI.HeatFlowRate[nSegTot,i] QAggShi_flow
    "Shifted vector of aggregated loads";
  Modelica.Units.SI.HeatFlowRate[nSegTot] QBor_flow_1d
    "Flattened array of heat flows (QBor_flow)";
  Modelica.Units.SI.TemperatureDifference[nSegTot] delTBor_1d
    "Flattened array of temperature differences (delTBor)";
  discrete Integer curCel "Current occupied cell";

  discrete Modelica.Units.SI.TemperatureDifference[nSegTot] delTBor0
    "Previous time step's temperature difference current borehole wall temperature minus initial borehole temperature";
  discrete Real[nSegTot] derDelTBor0(unit="K/s")
    "Derivative of wall temperature change from previous time steps";
  final parameter Real[nSegTot] dTStepdt(each fixed=false)
    "Time derivative of h_ii/(2*pi*H*Nb*ks) within most recent cell";

  Modelica.Units.SI.Heat[nSegTot,1] U "Accumulated heat flow from all segments";
  discrete Modelica.Units.SI.Heat[nSegTot,1] U_old
    "Accumulated heat flow from all segments at last aggregation step";

initial equation
  QAgg_flow = zeros(nSegTot,i);
  curCel = 1;
  delTBor_1d = zeros(nSegTot);
  QAggShi_flow = QAgg_flow;
  delTBor0 = zeros(nSegTot);
  U = zeros(nSegTot,1);
  U_old = zeros(nSegTot,1);
  derDelTBor0 = zeros(nSegTot);

  (nu,rCel) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.aggregationCellTimes(
    i=i,
    lvlBas=lvlBas,
    nCel=nCel,
    tLoaAgg=tLoaAgg,
    timFin=timFin);

  t_start = time;

  kappa =
    Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.temperatureResponseMatrix(
      nBor=borFieDat.conDat.nBor,
      cooBor=borFieDat.conDat.cooBor,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      aSoi=borFieDat.soiDat.aSoi,
      kSoi=borFieDat.soiDat.kSoi,
      nSeg=nSeg,
      nZon=borFieDat.conDat.nZon,
      iZon=borFieDat.conDat.iZon,
      nBorPerZon=borFieDat.conDat.nBorPerZon,
      nu=nu,
      nTim=i);

  dTStepdt = {kappa[i,i,1]/tLoaAgg for i in 1:nSegTot};

equation
  assert(
    time - t_start < timFin,
    "The simulation is longer than the calculated thermal response factors.
    Adjust the constant `timFin` in
    Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.GroundTemperatureResponse.");
  der(delTBor_1d) = dTStepdt .* QBor_flow_1d + derDelTBor0;
  der(U[:,1]) = QBor_flow_1d;
  for i in 1:nZon loop
    for j in 1:nSeg loop
      delTBor[i,j] = delTBor_1d[(i-1)* nSeg + j];
      QBor_flow[i,j] = QBor_flow_1d[(i-1)* nSeg + j];
    end for;
  end for;

  when sample(t_start, tLoaAgg) then
    // Assign average load since last aggregation step to the first cell of the
    // aggregation vector
    U_old = U;

    // Store (U - pre(U_old))/tLoaAgg in QAgg_flow[1], and pre(QAggShi_flow) in the other elements
    QAgg_flow = cat(2, (U - pre(U_old))/tLoaAgg, pre(QAggShi_flow[:,2:end]));
    // Shift loads in aggregation cells
    (curCel,QAggShi_flow) = Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.shiftAggregationCells(
      i=i,
      nSeg=nSegTot,
      QAgg_flow=QAgg_flow,
      rCel=rCel,
      nu=nu,
      curTim=(time - t_start));

    // Determine the temperature change at the next aggregation step (assuming
    // no loads until then)
    delTBor0 = Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer.temporalSuperposition(
      i=i,
      nSeg=nSegTot,
      QAgg_flow=QAggShi_flow,
      kappa=kappa,
      curCel=curCel);

    derDelTBor0 = (delTBor0 - delTBor_1d) / tLoaAgg;
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
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model calculates the ground temperature response to obtain the temperature
at the wall of each borehole segment in a geothermal system where heat is being
injected into or extracted from the ground.
</p>
<p>
A load-aggregation scheme based on that developed by Claesson and Javed (2012)
is used to calculate the borehole wall temperature response with the temporal
and spatial superpositions of ground thermal loads. In its base form, the
load-aggregation scheme uses fixed-length aggregation cells to agglomerate
thermal load history together, with more distant cells (denoted with a higher
cell and vector index) representing more distant thermal history. The more
distant the thermal load, the less impactful it is on the borehole wall
temperature change at the current time step. Each cell has an
<em>aggregation time</em> associated to it denoted by <code>nu</code>,
which corresponds to the simulation time (since the beginning of heat injection
or extraction) at which the cell will begin shifting its thermal load to more
distant cells. To determine <code>nu</code>, cells have a temporal size
<i>r<sub>cel</sub></i> (<code>rcel</code> in this model) which follows the
exponential growth :
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_01.png\" />
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
The weighting factors giving the impact of the thermal load in a cell
<i>m</i>) for a segment <i>v</i> of borehole <i>J</i> onto
the temperature at the wall of segment <i>u</i> of a borehole
<i>I</i> at the current time is obtained from analytical thermal response
factors:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_02.png\" />
</p>
<p>
where <i>h<sub>IJ,uv</sub></i> is the thermal response factor of segment
<i>v</i> of borehole <i>J</i> onto segment <i>u</i> of a
borehole <i>I</i>, <i>k<sub>s</sub></i> is the thermal
conductivity of the soil and <i>&nu;</i> refers to the vector <code>nu</code> in
this model.
</p>
<p>
At every aggregation time step, a time event is generated to perform the load aggregation steps.
First, the thermal loads are shifted. When shifting between cells of different size, total
energy is conserved. This operation is illustred in the figure below by Cimmino (2014).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_03.png\" />
</p>
<p>
After the cell-shifting operation is performed, the first aggregation cell has its
value set to the average thermal load since the last aggregation step.
Temporal superposition is then applied by means
of a scalar product between the aggregated thermal loads <code>QAgg_flow</code> and the
weighting factors <i>&kappa;</i>. The spatial superposition is applied by summing
the contributions of all segments on the total temperature variation.
</p>
<p>
Due to Modelica's variable time steps, the load aggregation scheme is modified by separating
the thermal response between the current aggregation time step and everything preceding it.
This is done according to :
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_04.png\" />
</p>
<p>
where <i>T<sub>b,I,u</sub></i> is the borehole wall temperature at segment
<i>u</i> of borehole <i>I</i>, <i>Q'<sub>b,J,v</sub></i> is the ground thermal
load per borehole length at segment <i>v</i> of borehole <i>J</i>. <i>t<sub>k</sub></i>
is the last discrete aggregation time step, meaning that the current time <i>t</i>
satisfies <i>t<sub>k</sub>&le;t&le;t<sub>k+1</sub></i>.
<i>&Delta;t<sub>agg</sub>(=t<sub>k+1</sub>-t<sub>k</sub>)</i> is the
parameter <code>tLoaAgg</code> in the present model.
</p>
<p>
Thermal interactions between segments affect the borehole wall temperature much
slower than the effect of heat extraction at a segment on the temperature variation
at the same segment. Thus, spatial superposition in the second sum can be
neglected :
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_05.png\" />
</br>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_06.png\" />
</p>
<p>
where <i>&Delta;T<sub>b,I,u</sub>*(t)</i> is the borehole wall temperature change
at segment <i>u</i> of borehole <i>I</i> due to the thermal history prior to the current
aggregation step. At every aggregation time step, spatial and temporal superpositions
are used to calculate its discrete value. Assuming no heat injection or extraction until
<i>t<sub>k+1</sub></i>, this term is assumed to have a linear
time derivative, which is given by the difference between <i>&Delta;T<sub>b,I,u</sub>*(t<sub>k+1</sub>)</i>
(the temperature change from load history at the next discrete aggregation time step, which
is constant over the duration of the ongoing aggregation time step) and the total
temperature change at the last aggregation time step, <i>&Delta;T<sub>b,I,u</sub>(t<sub>k</sub>)</i>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_07.png\" />
</p>
<p>
The second term <i>&Delta;T<sub>b,q,I,u</sub>(t)</i> concerns the ongoing aggregation time step.
To obtain the time derivative of this term, the thermal response factor <i>h<sub>II,uu</sub></i> is assumed
to vary linearly over the course of an aggregation time step. Therefore, because
the ongoing aggregation time step always concerns the first aggregation cell, its
derivative can be calculated as <code>kappa[i,i,1]</code>, the first value in the <code>kappa</code> array,
divided by the aggregation time step <i>&Delta;t</i>.
The derivative of the temperature change at the borehole wall is then expressed
by its multiplication with the heat flow <i>Q<sub>I,u</sub></i> at
the borehole wall.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_08.png\" />
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_09.png\" />
</p>
<p>
With the two terms in the expression of <i>&Delta;T<sub>b,I,u</sub>(t)</i> expressed
as time derivatives, <i>&Delta;T<sub>b,I,u</sub>(t)</i> can itself also be
expressed as its time derivative and implemented as such directly in the Modelica
equations block with the <code>der()</code> operator.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedThermalStorage/LoadAggregation_10.png\" />
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
</html>", revisions="<html>
<ul>
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
