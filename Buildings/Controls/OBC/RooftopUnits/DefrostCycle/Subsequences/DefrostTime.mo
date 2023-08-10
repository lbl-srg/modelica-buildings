within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences;
block DefrostTime "Sequences to determine defrost time"
  extends Modelica.Blocks.Icons.Block;

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa")=101325
    "Atmospheric pressure";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.RealOutput yDefFra(final unit="1")
    "Defrost operation timestep fraction"
    annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi ent
    annotation (Placement(transformation(extent={{-68,-30},{-48,-10}})));
  CDL.Continuous.Subtract sub
    annotation (Placement(transformation(extent={{-20,-36},{0,-16}})));
  CDL.Continuous.Sources.Constant con(k=1006)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  CDL.Continuous.Divide div1
    annotation (Placement(transformation(extent={{40,-42},{60,-22}})));
  CDL.Continuous.Sources.Constant con1(k=2501014.5)
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  CDL.Continuous.Sources.Constant con2(k=1860)
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  CDL.Continuous.Multiply mul1
    annotation (Placement(transformation(extent={{0,56},{20,76}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations defTimFra
    annotation (Placement(transformation(extent={{38,-82},{58,-62}})));
protected
  Real TCoiOut(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Outdoor coil temperature";
  Real p_s(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa")
    "Saturated water vapor pressure";
  Real p_v(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa")
    "Water vapor partial pressure";
  Real w_s(
    final unit="1")
    "Saturated water vapor mass fraction in kg per kg dry air";
  Real w_v(
    final unit="1",
    nominal=0.01)
    "Water vapor mass fraction in kg per kg dry air";
  Real delta_w(
    final unit="1")
    "Humdity ratio diference";

equation
  TCoiOut=(0.82*(TOut-273.15)-8.589)+273.15;
  p_s=Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TCoiOut);
  p_v=phi*p_s;
  w_s=0.6219647130774989*p_s/(pAtm-p_s);
  w_v=0.6219647130774989*p_v/(pAtm-p_v);
  delta_w=max(1.0e-6,w_v-w_s);
  yDefTim=1/(1+(0.01446/delta_w));

  connect(ent.TDryBul, TOut) annotation (Line(points={{-70,-14},{-80,-14},{-80,
          60},{-120,60}},               color={0,0,127}));
  connect(phi, ent.phi) annotation (Line(points={{-120,-60},{-74,-60},{-74,-26},
          {-70,-26}},
                    color={0,0,127}));
  connect(ent.h, sub.u1)
    annotation (Line(points={{-46,-20},{-22,-20}},        color={0,0,127}));
  connect(TOut, mul.u2) annotation (Line(points={{-120,60},{-80,60},{-80,14},{
          -42,14}},                                 color={0,0,127}));
  connect(con.y, mul.u1) annotation (Line(points={{-48,40},{-44,40},{-44,26},{
          -42,26}},
                color={0,0,127}));
  connect(mul.y, sub.u2) annotation (Line(points={{-18,20},{-10,20},{-10,0},{
          -30,0},{-30,-32},{-22,-32}},   color={0,0,127}));
  connect(sub.y, div1.u1) annotation (Line(points={{2,-26},{38,-26}},
        color={0,0,127}));
  connect(mul1.y, add2.u2) annotation (Line(points={{22,66},{32,66},{32,14},{48,
          14}}, color={0,0,127}));
  connect(con1.y, add2.u1) annotation (Line(points={{72,80},{80,80},{80,54},{40,
          54},{40,26},{48,26}},
                        color={0,0,127}));
  connect(add2.y, div1.u2) annotation (Line(points={{72,20},{78,20},{78,6},{32,
          6},{32,-38},{38,-38}},  color={0,0,127}));
  connect(defTimFra.TOut, TOut) annotation (Line(points={{37,-70},{-80,-70},{
          -80,60},{-120,60}},                                 color={0,0,127}));
  connect(div1.y, defTimFra.XOut) annotation (Line(points={{62,-32},{70,-32},{
          70,-50},{30,-50},{30,-74},{37,-74}},
                                            color={0,0,127}));
  connect(defTimFra.tDefFra, yDefFra) annotation (Line(points={{59,-68},{80,-68},
          {80,0},{120,0}}, color={0,0,127}));
  connect(TOut, mul1.u2)
    annotation (Line(points={{-120,60},{-2,60}}, color={0,0,127}));
  connect(con2.y, mul1.u1) annotation (Line(points={{-18,80},{-10,80},{-10,72},
          {-2,72}}, color={0,0,127}));
  annotation (
    defaultComponentName="DefTim",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DefrostTime;
