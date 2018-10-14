within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block CapacityRequirement
  "Required cooling capacity at given flow, chilled water return and supply setpoint temperatures"

  parameter Real water_density(quantity="Density", unit="kg/m3") = 1000
  "Water density";

  parameter Real water_cp = 4184
  "Specific heat capacity of water Fixme: unit and quantity";

  parameter Modelica.SIunits.Time avePer = 5*60
  "Period for the rolling average";

  CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-120,40},{-100,60}})));
  CDL.Interfaces.RealInput TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s") "Measured chilled water flow rate" annotation (Placement(
        transformation(extent={{-140,-70},{-100,-30}}), iconTransformation(
          extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.Add add2(k1=-1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  CDL.Interfaces.RealOutput yCapReq(
    final quantity="Power",
    final unit="W")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Continuous.MovingMean movMea(delta=avePer)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Continuous.Sources.Constant density(k=water_density) "Water density"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Continuous.Sources.Constant speHeaCap(k=water_cp)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Continuous.Product pro2
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(TChiWatRet, add2.u2) annotation (Line(points={{-120,20},{-60,20},{-60,
          24},{-42,24}}, color={0,0,127}));
  connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-42,36},{-60,36},{-60,
          80},{-120,80}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{-19,30},{-10,30},{-10,6},{
          28,6}},
               color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{51,0},{58,0}}, color={0,0,127}));
  connect(yCapReq, movMea.y)
    annotation (Line(points={{110,0},{81,0}}, color={0,0,127}));
  connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-59,-70},{-50,-70},{
          -50,-66},{-42,-66}}, color={0,0,127}));
  connect(pro1.y, pro2.u2) annotation (Line(points={{-19,-60},{-10,-60},{-10,
          -36},{-2,-36}}, color={0,0,127}));
  connect(pro.u2, pro2.y) annotation (Line(points={{28,-6},{24,-6},{24,-30},{21,
          -30}}, color={0,0,127}));
  connect(pro1.u1, density.y) annotation (Line(points={{-42,-54},{-50,-54},{-50,
          -20},{-59,-20}}, color={0,0,127}));
  connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-120,-50},{-80,-50},
          {-80,-40},{-20,-40},{-20,-24},{-2,-24}}, color={0,0,127}));
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
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Fixme
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacityRequirement;
