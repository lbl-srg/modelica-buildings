within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilDryWetRegime
  "Model implementing the switching algorithm of the TK-fuzzy model for cooling coil application"

  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(min=0)
    "Nominal mass flow rate for water"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(min=0)
    "Nominal mass flow rate for air"
    annotation (Dialog(group="Nominal condition"));

  input Real Qfac(final unit="1")
    "Smoothing factor to prevent division-by-zero";

  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg=
    Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow
    "Heat exchanger configuration";

  // -- Water
  Modelica.Blocks.Interfaces.RealInput UAWat(
    final quantity="ThermalConductance",
    final unit="W/K")
    "Product of heat transfer coefficient times area for water side"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}}),
        iconTransformation(extent={{-160,100},{-140,120}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(
    quantity="MassFlowRate",
    min = 0,
    final unit="kg/s")
    "Mass flow rate for water"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}}),
        iconTransformation(extent={{-160,80},{-140,100}})));
  Modelica.Blocks.Interfaces.RealInput cpWat(
    final quantity="SpecificHeatCapacity",
    final unit="J/(kg.K)")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}}),
        iconTransformation(extent={{-160,60},{-140,80}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}}),
        iconTransformation(extent={{-160,40},{-140,60}})));
  // -- Air
  Modelica.Blocks.Interfaces.RealInput UAAir(
    final quantity="ThermalConductance",
    final unit="W/K")
    "Product of heat transfer coefficient times area for air side"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}}),
        iconTransformation(extent={{-160,-120},{-140,-100}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow(
    quantity="MassFlowRate",
    min = 0,
    final unit="kg/s")
    "Mass flow rate for air"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}}),
        iconTransformation(extent={{-160,-100},{-140,-80}})));
  Modelica.Blocks.Interfaces.RealInput cpAir(
    final quantity="SpecificHeatCapacity",
    final unit="J/(kg.K)")
    "Inlet specific heat capacity (at constant pressure)"
    annotation (Placement(
        transformation(extent={{-160,-80},{-140,-60}}), iconTransformation(
          extent={{-160,-80},{-140,-60}})));
  Modelica.Blocks.Interfaces.RealInput TAirIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 200,
    start = 288.15,
    nominal = 300,
    displayUnit="degC")
    "Inlet air temperature"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}}),
        iconTransformation(extent={{-160,-60},{-140,-40}})));
  Modelica.Blocks.Interfaces.RealInput hAirIn(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    "Inlet air enthalpy"
    annotation (
      Placement(transformation(extent={{-160,-40},{-140,-20}}),
        iconTransformation(extent={{-160,-40},{-140,-20}})));
  Modelica.Blocks.Interfaces.RealInput pAir(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=70000,
    nominal = 1e5)
    "Inlet air absolute pressure"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}}),
        iconTransformation(extent={{-160,-20},{-140,0}})));
  Modelica.Blocks.Interfaces.RealInput X_wAirIn(
    min=0,
    max=1,
    unit="1")
    "Mass fraction of water in inlet air (kg water/kg total air)"
    annotation (
      Placement(transformation(extent={{-160,0},{-140,20}}), iconTransformation(
          extent={{-160,0},{-140,20}})));

  Modelica.Blocks.Interfaces.RealOutput QTot_flow(
    final quantity="Power",
    final unit="W")
    "Total heat transfer from water into air, negative for cooling"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-20})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat transfer from water into air, negative for cooling"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-60})));
  Modelica.Units.SI.HeatFlowRate QLat_flow "Latent heat transfer rate";

  Modelica.Blocks.Interfaces.RealOutput mCon_flow(
    quantity="MassFlowRate",
    final unit="kg/s")
    "Mass flow of the condensate, negative for dehumidification"
    annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-100})));
  Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilDryRegime fullyDry(
    final UAWat=UAWat,
    final mWat_flow=mWat_flow,
    final cpWat=cpWat,
    final TWatIn=TWatIn,
    final UAAir=UAAir,
    final mAir_flow=mAir_flow,
    final mWatNonZer_flow=mWatNonZer_flow,
    final mAirNonZer_flow=mAirNonZer_flow,
    final cpAir=cpAir,
    final TAirIn=TAirIn,
    final cfg=cfg,
    final mAir_flow_nominal=mAir_flow_nominal,
    final mWat_flow_nominal=mWat_flow_nominal) "Fully-dry coil model";

  Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilWetRegime fullyWet(
    final UAWat=UAWat,
    final mWat_flow=mWat_flow,
    final cpWat=cpWat,
    final TWatIn=TWatIn,
    final UAAir=UAAir,
    final mAir_flow=mAir_flow,
    final mWatNonZer_flow=mWatNonZer_flow,
    final mAirNonZer_flow=mAirNonZer_flow,
    final cpAir=cpAir,
    final TAirIn=TAirIn,
    final cfg=cfg,
    final mAir_flow_nominal=mAir_flow_nominal,
    final mWat_flow_nominal=mWat_flow_nominal,
    final pAir=pAir,
    final X_wAirIn=X_wAirIn) "Fully-wet coil model";

  Real dryFra(final unit="1", min=0, max=1)
    "Dry fraction, 0.3 means condensation occurs at 30% heat exchange length from air inlet";
protected
  Modelica.Units.SI.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps) =
    Buildings.Utilities.Math.Functions.smoothMax(
    x1=mAir_flow,
    x2=1E-3*mAir_flow_nominal,
    deltaX=0.25E-3*mAir_flow_nominal) "Mass flow rate of air";
  Modelica.Units.SI.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps) =
    Buildings.Utilities.Math.Functions.smoothMax(
    x1=mWat_flow,
    x2=1E-3*mWat_flow_nominal,
    deltaX=0.25E-3*mWat_flow_nominal) "Mass flow rate of water";

  Modelica.Units.SI.Temperature TAirInDewPoi
    "Dew point temperature of incoming air";

  Buildings.Utilities.Psychrometrics.pW_X pWIn(
    final X_w=X_wAirIn,
    final p_in=pAir);
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewIn(
    final p_w=pWIn.p_w);

  //-- Values for fuzzy logics
  Real mu_FW(final unit="1", min=0, max=1), mu_FD(unit="1",min=0, max=1)
    "Membership functions for Fully-Wet and Fully-Dry conditions";
  Real w_FW(final unit="1", min=0, max=1),  w_FD(unit="1",min=0, max=1)
    "Normalized weight functions for Fully-Wet and Fully-Dry conditions";

equation

  TAirInDewPoi=TDewIn.T;

  mu_FW= Buildings.Utilities.Math.Functions.spliceFunction(
    pos=0,neg=1,x=fullyWet.TSurAirIn-TAirInDewPoi,
    deltax=Buildings.Utilities.Math.Functions.smoothMax(
      abs(fullyDry.TSurAirOut-fullyWet.TSurAirIn), 1e-2,1e-3));

  mu_FD= Buildings.Utilities.Math.Functions.spliceFunction(
    pos=1,neg=0,x=fullyDry.TSurAirOut-TAirInDewPoi,
    deltax=Buildings.Utilities.Math.Functions.smoothMax(
      abs(fullyDry.TSurAirOut-fullyWet.TSurAirIn), 1e-2,1e-3));

  w_FW=mu_FW/(mu_FW+mu_FD);
  w_FD=mu_FD/(mu_FW+mu_FD);

  QTot_flow= -(w_FW*fullyWet.QTot_flow+w_FD*fullyDry.QTot_flow)*Qfac;
  QSen_flow= -(w_FW*fullyWet.QSen_flow+w_FD*fullyDry.QTot_flow)*Qfac;
  dryFra= w_FD;

  QLat_flow=QTot_flow-QSen_flow;
  mCon_flow=QLat_flow/Buildings.Utilities.Psychrometrics.Constants.h_fg*Qfac;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},
            {140,120}}), graphics={
        Rectangle(
          extent={{-140,120},{140,-120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          pattern=LinePattern.Dot,
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,40},{100,-40}},
          lineColor={28,108,200},
          fillColor={170,227,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{24,36},{96,2}},
          textStyle={TextStyle.Bold},
          pattern=LinePattern.None,
          textString="WET",
          lineColor={0,0,0}),
        Line(
          points={{20,0},{120,0}},
          color={28,108,200},
          thickness=1,
          pattern=LinePattern.Dash),
        Ellipse(
          extent={{72,0},{66,-6}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{82,-4},{76,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,0},{88,-8}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,-4},{58,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{54,0},{48,-6}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{42,-4},{36,-10}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,0},{24,-8}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,40},{20,-40}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-16,-4},{56,-38}},
          textStyle={TextStyle.Bold},
          textString="CALCS",
          pattern=LinePattern.None),
        Line(
          points={{-80,0},{20,0}},
          color={28,108,200},
          thickness=1,
          pattern=LinePattern.Dash),
        Text(
          extent={{-56,36},{16,2}},
          textStyle={TextStyle.Bold},
          textString="DRY",
          pattern=LinePattern.None),
        Text(
          extent={{-22,60},{58,40}},
          textColor={28,108,200},
          fillColor={170,170,255},
          fillPattern=FillPattern.Forward,
          textString="Water",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{-20,-40},{60,-60}},
          textColor={28,108,200},
          fillColor={170,170,255},
          fillPattern=FillPattern.Forward,
          textString="Air",
          textStyle={TextStyle.Italic}),
        Text(
          extent={{-116,-104},{-116,-116}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="hA"),
        Text(
          extent={{-116,116},{-116,104}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="hA"),
        Text(
          extent={{-116,96},{-116,84}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="masFlo"),
        Text(
          extent={{-116,76},{-116,64}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="cp"),
        Text(
          extent={{-116,56},{-116,44}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="T_in"),
        Text(
          extent={{-116,-84},{-116,-96}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="masFlo"),
        Text(
          extent={{-116,-64},{-116,-76}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="cp"),
        Text(
          extent={{-116,-44},{-116,-56}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="T_in"),
        Text(
          extent={{-116,-24},{-116,-36}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="h_in"),
        Text(
          extent={{-116,-4},{-116,-16}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="p_in"),
        Text(
          extent={{-116,16},{-116,4}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="w_in"),
        Text(
          extent={{120,-12},{120,-24}},
          textColor={28,108,200},
          textString="QTot_flow"),
        Text(
          extent={{104,-94},{104,-106}},
          textColor={28,108,200},
          textString="mCon_flow"),
        Text(
          extent={{118,-52},{118,-64}},
          textColor={28,108,200},
          textString="QSen")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
    Documentation(revisions="<html>
<ul>
<li>
Jan 21, 2021, by Donghun Kim:<br/>First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model implements the switching algorithm for the dry and wet regime.
</p>
<p>
The switching criteria for (counter-flow) cooling coil modes are as follows.</p>
<p>
R1: If the coil surface temperature at the air inlet is lower than the dew-point
temperature at the inlet to the coil, then the cooling coil surface is fully-wet.</p>
<p>
R2: If the surface temperature at the air outlet section is higher than
the dew-point temperature of the air at the inlet, then the cooling coil surface is fully-dry.</p>
<p>
At each point of a simulation time step, the fuzzy-modeling approach determines
the weights for R1 and R2 respectively (namely <i>&mu;<sub>FW</sub></i> and <i>&mu;<sub>FD</sub></i>)
from the dew-point and coil surface temperatures.</p>
<p>
It calculates total and sensible heat transfer rates according to the weights as follows.
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>tot</sub>=&mu;<sub>FD</sub> Q&#775;<sub>tot,FD</sub>+&mu;<sub>FW</sub> Q<sub>tot,FW</sub>
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>sen</sub>=&mu;<sub>FD</sub> Q&#775;<sub>sen,FD</sub>+&mu;<sub>FW</sub> Q<sub>sen,FW</sub>
</p>
<p>
The fuzzy-modeling ensures <i>&mu;<sub>FW</sub> + &mu;<sub>FD</sub> = 1</i>,
<i>&mu;<sub>FW</sub> &gt;=0</i> and <i>&mu;<sub>FD</sub> &gt;=0</i>, which means the fuzzy
model outcomes of <i>Q&#775;<sub>sen</sub></i> and <i>Q&#775;<sub>tot</sub></i> are always convex combinations of heat transfer
rates for fully-dry and fully-wet modes and therefore are always bounded by them.
</p>
<p>
The modeling approach also results in <i>n</i>-th order differentiable model
depending on the selection of the underlying membership functions. This cooling
coil model is once continuously differentiable at the mode switches.
</p>
</html>"));
end WetCoilDryWetRegime;
