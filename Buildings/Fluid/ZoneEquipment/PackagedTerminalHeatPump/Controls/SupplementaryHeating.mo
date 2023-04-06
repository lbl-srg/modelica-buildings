within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls;
block SupplementaryHeating "Activation of supplementary heating"

  parameter Real TDryCom_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15-8
    "Minimum outdoor dry-bulb temperature for compressor operation";
    parameter Real k=1 "Gain of controller"
  annotation (Dialog(group="Controller"));
  parameter Modelica.Units.SI.Time Ti=120 "Time constant of Integrator block"
  annotation (Dialog(group="Controller"));


  Modelica.Blocks.Interfaces.BooleanInput uHeaMod
    "When heating mode is enabled"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air dry bulb temperature" annotation (Placement(transformation(
          extent={{-200,-30},{-160,10}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupHea(
    final min=0,
    final max=1,
    final unit="1") "Supplementary heating control signal" annotation (
      Placement(transformation(extent={{160,-20},{200,20}}), iconTransformation(
          extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(t=TDryCom_min)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "supplementary heating signal switch based on the outdoor air condition"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-100,-48},{-80,-28}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Whether the supplementary heating is activated based on the heating mode and outdoor air temperature"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Buildings.Controls.Continuous.LimPID conPI(
    k=k,
    yMax=1,
    yMin=0,
    Ti=Ti)  "Controller"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Modelica.Blocks.Interfaces.BooleanOutput yHeaEna "Heating enable signal"
                            annotation (Placement(transformation(extent={{160,-70},
            {200,-30}}),iconTransformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "DX heating coil enable signal switch based on whether to turn on supplementary heating"
    annotation (Placement(transformation(extent={{22,-60},{42,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(k=false)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Blocks.Interfaces.BooleanInput uHeaEna
    "DX heating coil enable signal" annotation (Placement(transformation(extent={{-200,
            -100},{-160,-60}}),       iconTransformation(extent={{-120,-40},{
            -100,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput uFan "Fan enable signal" annotation (
      Placement(transformation(extent={{-200,-150},{-160,-110}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2
    "Fan enable signal switch based on whether to turn on supplementary heating"
    annotation (Placement(transformation(extent={{22,-120},{42,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=true)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1") "Fan control signal" annotation (Placement(transformation(
          extent={{160,-130},{200,-90}}), iconTransformation(extent={{100,-40},
            {140,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Math.Mean ySupHeaMea(f=1/900)
    annotation (Placement(transformation(extent={{74,20},{94,40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold
                                                      greThr(t=0.05, h=0.05)
    annotation (Placement(transformation(extent={{108,20},{128,40}})));
equation
  connect(TOut,lesThr. u)
    annotation (Line(points={{-180,-10},{-140,-10},{-140,0},{-102,0}},
                                                     color={0,0,127}));
  connect(lesThr.y, and2.u1) annotation (Line(points={{-78,0},{-68,0},{-68,-8},
          {-62,-8}},  color={255,0,255}));
  connect(and2.y, swi.u2) annotation (Line(points={{-38,-8},{-24,-8},{-24,0},{
          18,0}}, color={255,0,255}));
  connect(con.y, swi.u3) annotation (Line(points={{-78,-38},{-20,-38},{-20,-8},
          {18,-8}},color={0,0,127}));
  connect(THeaSet, conPI.u_s) annotation (Line(points={{-180,30},{-120,30},{-120,
          50},{-62,50}}, color={0,0,127}));
  connect(TZon, conPI.u_m) annotation (Line(points={{-180,70},{-80,70},{-80,28},
          {-50,28},{-50,38}}, color={0,0,127}));
  connect(conPI.y, swi.u1) annotation (Line(points={{-39,50},{-20,50},{-20,8},{18,
          8}}, color={0,0,127}));
  connect(and2.y, logSwi1.u2) annotation (Line(points={{-38,-8},{-10,-8},{-10,
          -50},{20,-50}}, color={255,0,255}));
  connect(logSwi1.y, yHeaEna)
    annotation (Line(points={{44,-50},{180,-50}}, color={255,0,255}));
  connect(fal.y, logSwi1.u1) annotation (Line(points={{-38,-60},{-2,-60},{-2,
          -42},{20,-42}}, color={255,0,255}));
  connect(uHeaEna, logSwi1.u3) annotation (Line(points={{-180,-80},{6,-80},{6,
          -58},{20,-58}}, color={255,0,255}));
  connect(tru.y, logSwi2.u1) annotation (Line(points={{-38,-90},{-10,-90},{-10,
          -102},{20,-102}}, color={255,0,255}));
  connect(uFan, logSwi2.u3) annotation (Line(points={{-180,-130},{-16,-130},{
          -16,-118},{20,-118}}, color={255,0,255}));
  connect(logSwi2.y, booToRea.u)
    annotation (Line(points={{44,-110},{78,-110}}, color={255,0,255}));
  connect(booToRea.y, yFan) annotation (Line(points={{102,-110},{138,-110},{138,
          -110},{180,-110}}, color={0,0,127}));
  connect(swi.y, ySupHea)
    annotation (Line(points={{42,0},{180,0}}, color={0,0,127}));
  connect(uHeaMod, and2.u2) annotation (Line(points={{-180,-50},{-120,-50},{
          -120,-16},{-62,-16}}, color={255,0,255}));
  connect(swi.y, ySupHeaMea.u)
    annotation (Line(points={{42,0},{60,0},{60,30},{72,30}}, color={0,0,127}));
  connect(ySupHeaMea.y, greThr.u)
    annotation (Line(points={{95,30},{106,30}}, color={0,0,127}));
  connect(greThr.y, logSwi2.u2) annotation (Line(points={{130,30},{140,30},{140,
          -88},{0,-88},{0,-110},{20,-110}}, color={255,0,255}));
annotation (defaultComponentName="uSupHea",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,100}})),
Documentation(info="<html>
</html>",revisions="<html>
<ul>
<li>
</li>
</ul>
</html>"));
end SupplementaryHeating;
