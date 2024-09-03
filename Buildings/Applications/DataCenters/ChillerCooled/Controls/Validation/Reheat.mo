within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model Reheat "Test model for reheater controller"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.Reheat heaCon(
    yValSwi=0.2,
    yValDeaBan=0.1,
    dTSwi=0,
    dTDeaBan=0.5,
    tWai=60) "Heater on/off controller"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Sine sig1(
    amplitude=0.3,
    offset=0.3,
    f=1/1200) "Signal 1"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine sig2(
    amplitude=3,
    offset=273.15 + 15,
    f=1/1200,
    phase=1.0471975511966) "Signal 2"
    annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
  Modelica.Blocks.Sources.Constant set1(k=0.2) "Set point for signal 1"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant set2(k=273.15 + 16) "Set point for signal 2"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Add add1(k1=+1, k2=-1)
    "Error between signal 1 and setpoint 1"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Math.Add add2(k1=+1, k2=-1)
    "Error between signal 2 and setpoint 2"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(sig1.y, add1.u1)
    annotation (Line(points={{-59,50},{-52,50},{-52,36},{
          -22,36}}, color={0,0,127}));
  connect(set1.y, add1.u2)
    annotation (Line(points={{-59,10},{-52,10},{-52,24},{
          -22,24}}, color={0,0,127}));
  connect(add1.y, heaCon.yVal)
    annotation (Line(points={{1,30},{20,30},{20,5},{38,5}}, color={0,0,127}));
  connect(sig2.y, add2.u1)
    annotation (Line(points={{-59,-28},{-52,-28},{-52,-44},
          {-22,-44}}, color={0,0,127}));
  connect(set2.y, add2.u2)
    annotation (Line(points={{-59,-70},{-52,-70},{-52,-56},
          {-22,-56}}, color={0,0,127}));
  connect(add2.y,heaCon.dT)
    annotation (Line(points={{1,-50},{20,-50},{20,-5},{
          38,-5}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1200),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/Reheat.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example tests the reheater controller with two varing input error signals.</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Reheat;
