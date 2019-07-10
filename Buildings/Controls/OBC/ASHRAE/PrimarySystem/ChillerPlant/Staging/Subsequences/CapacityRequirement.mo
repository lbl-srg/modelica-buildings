within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block CapacityRequirement
  "Cooling capacity requirement"

  parameter Modelica.SIunits.Density watDen = 1000 "Water density";

  parameter Modelica.SIunits.SpecificHeatCapacity watSpeHea = 4184
  "Specific heat capacity of water";

  parameter Modelica.SIunits.Time avePer = 300
  "Period for the rolling average";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
    iconTransformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Power",
    final unit="W") "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant density(
    final k = watDen)
    "Water density"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speHeaCap(
    final k = watSpeHea)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLim(
    final k=0)
    "Minimum capacity requirement limit"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1) "Adder"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    final delta=avePer)
    "Moving average"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro2 "Product"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum of two inputs"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(TChiWatRet, add2.u2) annotation (Line(points={{-160,20},{-130,20},{-130,
          44},{-122,44}},color={0,0,127}));
  connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-122,56},{-130,56},{
          -130,80},{-160,80}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{-99,50},{-70,50},{-70,6},{
          18,6}}, color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-99,-70},{-90,-70},{
          -90,-56},{-82,-56}}, color={0,0,127}));
  connect(pro1.y, pro2.u2) annotation (Line(points={{-59,-50},{-50,-50},{-50,
          -16},{-22,-16}}, color={0,0,127}));
  connect(pro.u2, pro2.y) annotation (Line(points={{18,-6},{10,-6},{10,-10},{1,
          -10}}, color={0,0,127}));
  connect(pro1.u1, density.y) annotation (Line(points={{-82,-44},{-90,-44},{-90,
          -30},{-99,-30}}, color={0,0,127}));
  connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-160,-60},{-130,-60},
          {-130,-4},{-22,-4}}, color={0,0,127}));
  connect(max.u1, minLim.y) annotation (Line(points={{98,6},{90,6},{90,50},{81,
          50}}, color={0,0,127}));
  connect(movMea.y, max.u2) annotation (Line(points={{81,0},{90,0},{90,-6},{98,
          -6}}, color={0,0,127}));
  connect(max.y, y) annotation (Line(points={{121,0},{150,0}}, color={0,0,127}));
  annotation (defaultComponentName = "capReq",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,88},{60,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Load")}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
Documentation(info="<html>
<p>
Calculates cooling capacity requirement based on the measured chilled water return temperature
(CHWRT), <code>TChiWatRet<\code>, calculated chilled water supply temperature setpoint (CHWST setpoint),
<code>TChiWatSupSet<\code>, and the measured chilled water flow, <code>VChiWat_flow<\code>.
<li>
The calculation is according to Draft 4, section 5.2.4.3.
</li>
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacityRequirement;
