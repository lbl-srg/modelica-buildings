within Buildings.Fluid.CHPs.BaseClasses.Validation;
model EnergyConversion "Validate model EnergyConversion"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter Data.ValidationData2 per1(warmUpByTimeDelay=true)
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneConEngTem(
    final per=per)
    "Energy conversion volume: warm-up by engine temperature"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneConTimDel(
    final per=per1)
    "Energy conversion volume: warm-up by time delay"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.4; 2700,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Cooling water flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per) "Operation mode"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=false, table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TEng(
    final height=90,
    final duration=600,
    final offset=273.15 + 15,
    final startTime=360) "Engine temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWatIn(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15) "Cooling water inlet temperature"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Sources.TimeTable PEle(
    table=[0,0; 299,0; 300,2500; 2699,2500;2700,0; 3000,0])
    "Electric power demand"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Controls.OBC.CDL.Reals.Sources.Constant TRoo(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(con.opeMod, eneConEngTem.opeMod) annotation (Line(points={{21,80},{40,
          80},{40,-25},{59,-25}}, color={0,127,0}));
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-59,80},{-30,80},{-30,
          87},{-2,87}}, color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,40},{-54,40},{-54,
          84},{-2,84}}, color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-58,-30},{-40,-30},{-40,
          78},{-2,78}},
                    color={0,0,127}));
  connect(TEng.y, eneConEngTem.TEng) annotation (Line(points={{-58,-30},{0,-30},
          {0,-37},{58,-37}}, color={0,0,127}));
  connect(TWatIn.y, eneConEngTem.TWatIn) annotation (Line(points={{-8,0},{20,0},
          {20,-31},{58,-31}}, color={0,0,127}));
  connect(PEle.y, eneConEngTem.PEle) annotation (Line(points={{-9,40},{30,40},{
          30,-22},{58,-22}}, color={0,0,127}));
  connect(mWat_flow.y[1], eneConEngTem.mWat_flow) annotation (Line(points={{-58,0},
          {-48,0},{-48,-28},{58,-28}},    color={0,0,127}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-58,0},{-48,
          0},{-48,81},{-2,81}}, color={0,0,127}));
  connect(TWatIn.y, eneConTimDel.TWatIn) annotation (Line(points={{-8,0},{20,0},
          {20,-71},{58,-71}}, color={0,0,127}));
  connect(mWat_flow.y[1], eneConTimDel.mWat_flow) annotation (Line(points={{-58,0},
          {-48,0},{-48,-68},{58,-68}},    color={0,0,127}));
  connect(PEle.y, eneConTimDel.PEle) annotation (Line(points={{-9,40},{30,40},{
          30,-62},{58,-62}}, color={0,0,127}));
  connect(con.opeMod, eneConTimDel.opeMod) annotation (Line(points={{21,80},{40,
          80},{40,-65},{59,-65}}, color={0,127,0}));
  connect(PEle.y, con.PEle) annotation (Line(points={{-9,40},{-6,40},{-6,72},{
          -2,72}}, color={0,0,127}));
  connect(eneConEngTem.PEleNet, con.PEleNet) annotation (Line(points={{82,-22},
          {90,-22},{90,96},{-6,96},{-6,75},{-2,75}}, color={0,0,127}));
  connect(TRoo.y, eneConEngTem.TRoo) annotation (Line(points={{-8,-50},{50,-50},
          {50,-34},{58,-34}}, color={0,0,127}));
  connect(TRoo.y, eneConTimDel.TRoo) annotation (Line(points={{-8,-50},{50,-50},
          {50,-74},{58,-74}}, color={0,0,127}));
annotation (
  experiment(StopTime=3000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/EnergyConversion.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversion\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversion</a>
for defining the energy conversion control volume.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversion;
