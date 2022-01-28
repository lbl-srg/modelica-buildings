within Buildings.Fluid.Storage.Ice.BaseClasses;
model TankHeatTransfer "Block to compute the tank heat transfer"
  extends Modelica.Blocks.Icons.Block;

  constant Modelica.Units.SI.TemperatureDifference dTSmall(min=1E-3) = 0.01 "Small temperature difference";

  parameter Real SOC_start(min=0, max=1, final unit="1")
   "Start value for state of charge"
    annotation(Dialog(tab = "Initialization"));

  replaceable parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{72,70},{92,90}})));

  final parameter Modelica.Units.SI.Energy QSto_nominal=per.Hf*per.mIce_max "Normal stored energy";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp "Specific heat capacity of working fluid";

  Modelica.Blocks.Interfaces.RealInput TIn(final unit="K", displayUnit="degC")
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TOut(final unit="K", displayUnit="degC")
    "Outlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));


  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Actual heat flow rate, taking into account 0 &le; SOC &le; 1"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput SOC(
    final unit = "1")
    "state of charge"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput mIce(
    quantity="Mass",
    unit="kg") "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  BaseClasses.StorageHeatTransferRate norQSta(
    final coeCha=per.coeCha,
    final coeDisCha=per.coeDisCha,
    final dtCha=per.dtCha,
    final dtDisCha=per.dtDisCha)
    annotation (Placement(transformation(extent={{8,66},{28,86}})));
  Modelica.Blocks.Math.Gain QCoe_flow(k=QSto_nominal, y(final unit="W"))
    "Heat flow rate based on performance curves, without any limitation"
    annotation (Placement(transformation(extent={{36,66},{56,86}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.LMTDStar lmtdSta(
    final TFre=per.TFre,
    final dT_nominal=per.dT_nominal)
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));

  Buildings.Fluid.Storage.Ice.BaseClasses.IceMass iceMas(
    final mIce_max=per.mIce_max,
    final SOC_start=SOC_start,
    final Hf=per.Hf)
    "Mass of the remaining ice"
    annotation (Placement(transformation(extent={{32,-80},{52,-60}})));

  Controls.OBC.CDL.Continuous.LessThreshold canFreeze(
    final t=per.TFre - dTSmall,
    final h=dTSmall/2)
    "Outputs true if temperatures allow ice to be produced"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold canMelt(
    final t=per.TFre + dTSmall,
    final h=dTSmall/2)
    "Outputs true if temperature allows tank to be melted"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  Modelica.Blocks.Interfaces.RealInput QLim_flow(final unit="W")
    "Limit on heat flow rate due to temperatures and mass flow rate"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
protected
  Modelica.Blocks.Math.Max QMax_flow "Maximum heat flow rate"
    annotation (Placement(transformation(extent={{-48,-96},{-28,-76}})));
  Modelica.Blocks.Math.Min QMin_flow "Miminum heat flow rate"
    annotation (Placement(transformation(extent={{-48,-66},{-28,-46}})));
  Modelica.Blocks.Logical.Switch QThe_flow
    "Heat flow rate extracted from fluid, not taking into account state of charge"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));


equation
  connect(norQSta.qNor, QCoe_flow.u)
    annotation (Line(points={{29,76},{34,76}}, color={0,0,127}));
  connect(iceMas.mIce, mIce) annotation (Line(points={{53,-76},{96,-76},{96,-40},
          {110,-40}}, color={0,0,127}));
  connect(QThe_flow.y, iceMas.Q_flow)
    annotation (Line(points={{21,-70},{30,-70}}, color={0,0,127}));
  connect(QMin_flow.y, QThe_flow.u1) annotation (Line(points={{-27,-56},{-8,-56},
          {-8,-62},{-2,-62}}, color={0,0,127}));
  connect(QCoe_flow.y, QMin_flow.u2) annotation (Line(points={{57,76},{60,76},{60,
          -20},{-56,-20},{-56,-62},{-50,-62}},                     color={0,0,127}));
  connect(QCoe_flow.y, QMax_flow.u1) annotation (Line(points={{57,76},{60,76},{60,
          -20},{-56,-20},{-56,-80},{-50,-80}},                     color={0,0,127}));
  connect(iceMas.SOC, SOC) annotation (Line(points={{53,-70},{80,-70},{80,0},{110,
          0}}, color={0,0,127}));
  connect(QMax_flow.y, QThe_flow.u3) annotation (Line(points={{-27,-86},{-8,-86},
          {-8,-78},{-2,-78}}, color={0,0,127}));
  connect(lmtdSta.lmtdSta, norQSta.lmtdSta) annotation (Line(points={{-27,70},{6,
          70}},                          color={0,0,127}));
  connect(iceMas.SOC, norQSta.fraCha) annotation (Line(points={{53,-70},{80,-70},
          {80,0},{0,0},{0,76},{6,76}}, color={0,0,127}));
  connect(norQSta.canMelt, canMelt.y) annotation (Line(points={{6,84},{-20,84},{
          -20,40},{-28,40}},
                           color={255,0,255}));
  connect(canFreeze.y, norQSta.canFreeze) annotation (Line(points={{-28,10},{-12,
          10},{-12,80},{6,80}},  color={255,0,255}));
  connect(canFreeze.y, QThe_flow.u2) annotation (Line(points={{-28,10},{-12,10},
          {-12,-70},{-2,-70}}, color={255,0,255}));
  connect(iceMas.QEff_flow, Q_flow) annotation (Line(points={{53,-64},{76,-64},{
          76,40},{110,40}}, color={0,0,127}));
  connect(lmtdSta.TIn, TIn) annotation (Line(points={{-50,74},{-90,74},{-90,60},
          {-120,60}}, color={0,0,127}));
  connect(canFreeze.u, TIn) annotation (Line(points={{-52,10},{-90,10},{-90,60},
          {-120,60}}, color={0,0,127}));
  connect(lmtdSta.TOut, TOut) annotation (Line(points={{-50,66},{-80,66},{-80,0},
          {-120,0}}, color={0,0,127}));
  connect(TIn, canMelt.u) annotation (Line(points={{-120,60},{-90,60},{-90,40},{
          -52,40}}, color={0,0,127}));
  connect(QLim_flow, QMin_flow.u1) annotation (Line(points={{-120,-60},{-58,-60},
          {-58,-50},{-50,-50}}, color={0,0,127}));
  connect(QLim_flow, QMax_flow.u2) annotation (Line(points={{-120,-60},{-58,-60},
          {-58,-92},{-50,-92}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Model that implements the heat transfer rate between the working fluid and the ice,
and that computes the state of charge of the tank.
</p>
<p>
See
<a href=\"Buildings.Fluid.Storage.Ice.Tank\">
Buildings.Fluid.Storage.Ice.Tank</a>
for the implemented equations.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
First implementation based on original model, but refactored to simplify model architecture.
</li>
</ul>
</html>"));
end TankHeatTransfer;
