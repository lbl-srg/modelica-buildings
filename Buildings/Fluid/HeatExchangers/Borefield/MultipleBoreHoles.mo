within Buildings.Fluid.HeatExchangers.Borefield;
model MultipleBoreHoles
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // Medium in borefield
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=bfData.m_flow_nominal,
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    final allowFlowReversal=false);

  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=true, dp_nominal=0);

  // General parameters of borefield
  replaceable parameter Borefield.Data.Records.BorefieldData bfData
    constrainedby Data.Records.BorefieldData
    "record containing all the parameters of the borefield model"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method";

  //General parameters of aggregation
  parameter Integer lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";

  // Load of borefield
  Modelica.SIunits.HeatFlowRate QAve_flow
    "Average heat flux over a time period";

  Modelica.SIunits.Temperature TWall "average borehole wall temperature";

  Modelica.Blocks.Sources.RealExpression TWall_val(y=TWall)
    annotation (Placement(transformation(extent={{-80,-54},{-58,-34}})));

  Modelica.SIunits.Power Q_flow
    "thermal power extracted or injected in the borefield";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TWallBou
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{-44,-54},{-24,-34}})));

  // Parameters for the aggregation technic
protected
  final parameter Integer p_max=5
    "number of aggregation cells within one aggregation level";
  final parameter Integer q_max=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbOfLevelAgg(n_max=integer(
      lenSim/bfData.gen.tStep), p_max=p_max) "number of aggregation levels";
  final parameter Real[q_max,p_max] kappaMat(fixed=false)
    "transient thermal resistance of each aggregation cells";
  final parameter Integer[q_max] rArr(fixed=false)
    "width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat(fixed=false)
    "nb of aggregated pulse at end of each aggregation cells";

  // Parameters for the calculation of the steady state resistance of the borefield
  final parameter Modelica.SIunits.Temperature TSteSta(fixed=false)
    "Quasi steady state temperature";
  final parameter Real R_ss(fixed=false) "steady state resistance";

  //Load
  Real[q_max,p_max] QMat
    "aggregation of load vector. Every discrete time step it is updated.";

  //Utilities
  Modelica.SIunits.Energy UOld "Internal energy at the previous period";
  Modelica.SIunits.Energy U
    "Current internal energy, defined as U=0 for t=tStart";
  Modelica.SIunits.Time startTime "Start time of the simulation";

public
  BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX
                                     intHEX(
    redeclare final package Medium = Medium,
    final m1_flow_nominal=bfData.gen.m_flow_nominal_bh,
    final m2_flow_nominal=bfData.gen.m_flow_nominal_bh,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=0,
    final from_dp1=from_dp,
    final from_dp2=from_dp,
    final linearizeFlowResistance1=linearizeFlowResistance,
    final linearizeFlowResistance2=linearizeFlowResistance,
    final deltaM1=deltaM,
    final deltaM2=deltaM,
    final m1_flow_small=bfData.gen.m_flow_small,
    final m2_flow_small=bfData.gen.m_flow_small,
    final soi=bfData.soi,
    final fil=bfData.fil,
    final gen=bfData.gen,
    final allowFlowReversal1=bfData.gen.allowFlowReversal,
    final allowFlowReversal2=bfData.gen.allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p_start,
    T1_start=bfData.gen.TFil0_start,
    X1_start=X_start,
    C1_start=C_start,
    C1_nominal=C_nominal,
    final p2_start=p_start,
    T2_start=bfData.gen.TFil0_start,
    X2_start=X_start,
    C2_start=C_start,
    C2_nominal=C_nominal,
    final scaSeg=bfData.gen.nbBh*bfData.gen.nVer)
    "Internal part of the borehole including the pipes and the filling material"
    annotation (Placement(transformation(extent={{-12,13},{12,-13}},
        rotation=270,
        origin={3,-10})));

initial algorithm
  // Initialisation of the internal energy (zeros) and the load vector. Load vector have the same lenght as the number of aggregated pulse and cover lenSim
  U := 0;
  UOld := 0;

  // Initialization of the aggregation matrix and check that the short-term response for the given bfData record has already been calculated
  (kappaMat,rArr,nuMat,TSteSta) :=
    Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts.saveAggregationMatrix(
    p_max=p_max,
    q_max=q_max,
    lenSim=lenSim,
    gen=bfData.gen,
    soi=bfData.soi,
    fil=bfData.fil);

  R_ss := TSteSta/(bfData.gen.q_ste*bfData.gen.hBor*bfData.gen.nbBh)
    "steady state resistance";

equation
  assert(time < lenSim, "The chosen value for lenSim is too small. It cannot cover the whole simulation time!");

  Q_flow = port_a.m_flow*(actualStream(port_a.h_outflow) - actualStream(port_b.h_outflow));

  der(U) = Q_flow
    "integration of load to calculate below the average load/(discrete time step)";

algorithm
  // Set the start time for the sampling
  when initial() then
    startTime := time;
  end when;

  when initial() or sample(startTime, bfData.gen.tStep) then
    QAve_flow := (U - UOld)/bfData.gen.tStep;
    UOld := U;

    // Update of aggregated load matrix. Careful: need of inversing order of loaVec (so that [end] = most recent load). FIXME: see if you can change that.
    QMat := Borefield.BaseClasses.Aggregation.aggregateLoad(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr,
      nuMat=nuMat,
      QNew=QAve_flow,
      QAggOld=QMat);

    TWall :=BaseClasses.deltaTWall(
      q_max=q_max,
      p_max=p_max,
      QMat=QMat,
      kappaMat=kappaMat,
      R_ss=R_ss) + bfData.gen.T_start;
  end when;

equation
  connect(TWall_val.y, TWallBou.T) annotation (Line(
      points={{-56.9,-44},{-46,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWallBou.port, intHEX.port) annotation (Line(
      points={{-24,-44},{-20,-44},{-20,-12},{-10,-12},{-10,-11.1818},{-8.81818,
          -11.1818}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(intHEX.port_b1, intHEX.port_a2) annotation (Line(
      points={{-4.09091,-23.1818},{-4.09091,-30},{10.0909,-30},{10.0909,
          -23.1818}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(port_a, intHEX.port_a1) annotation (Line(
      points={{-100,0},{-52,0},{-52,0.818182},{-4.09091,0.818182}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, intHEX.port_b2) annotation (Line(
      points={{100,0},{54,0},{54,2},{10.0909,2},{10.0909,0.818182}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
                    Documentation(info="<html>
  <p>The proposed model is a so-called hybrid step-response
model (HSRM). This type of model uses the
borefield’s temperature response to a step load input.
An arbitrary load can always be approximated by a superposition
of step loads. The borefield’s response to
the load is then calculated by superposition of the step responses
using the linearity property of the heat diffusion
equation. The most famous example of HSRM
for borefields is probably the <i>g-function</i> of Eskilson
(1987). The major challenge of this approach is to obtain a
HSRM which is valid for both minute-based and year-based
simulations. To tackle this problem, a HSRM
has been implemented. A long-term response model
is implemented in order to take into account
the interactions between the boreholes and the
temperature evolution of the surrounding ground. A
short-term response model is implemented to
describe the transient heat flux in the borehole heat exchanger to the surrounding
ground. The step-response of each model is then calculated and merged into one
in order to achieve both short- and long-term
accuracy. Finally an aggregation method is implemented to speed up the calculation.
However, the aggregation method calculates the temperature for discrete time step. In order to avoid
abrut temperature changes, the aggregation method is used to calculate the average borehole wall
temperature instead of the average fluid temperature. The calculated borehole wall temperature is then
connected to the dynamic model of the borehole heat exchanger.</p>
<p>More detailed documentation can be found in 
<a href=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
and in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Borefield.UsersGuide\">Buildings.Fluid.HeatExchangers.Borefield.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end MultipleBoreHoles;
