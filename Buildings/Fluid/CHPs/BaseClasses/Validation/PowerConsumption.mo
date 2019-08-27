within Buildings.Fluid.CHPs.BaseClasses.Validation;
model PowerConsumption "Validate model PowerConsumption"
  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable
                                    mWat_flow(table=[0,0; 300,0.4; 2700,0; 3000,
        0], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
                 "Water flow rate"
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(per=per)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=false, table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant
                               TEng(k=273.15 + 100)
                   "Engine temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Fluid.CHPs.BaseClasses.PowerConsumption powCon(per=per)
    "Internal controller for water flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-62,-99},{-42,-79}})));
equation
  connect(avaSig.y, con.avaSig)
    annotation (Line(points={{-59,80},{-40,80},{-40,6},{-11,6}},
                                                color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,40},{-50,40},{-50,
          2},{-11,2}},  color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-59,-40},{-40,-40},{-40,
          -6},{-11,-6}},
                    color={0,0,127}));
  connect(con.opeMod,powCon. opeMod) annotation (Line(points={{11,0},{38,0}},
                        color={0,127,0}));
  connect(mWat_flow.y[1], con.mWat_flow)
    annotation (Line(points={{-59,-2},{-11,-2}}, color={0,0,127}));
  annotation (
    experiment(StopTime=3000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/PowerConsumption.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.PowerConsumption\">
Buildings.Fluid.CHPs.BaseClasses.PowerConsumption</a>
for calculating the power consumption during the stand-by and cool-down modes of operation.
</p>
</html>", revisions="<html>
<ul>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end PowerConsumption;
