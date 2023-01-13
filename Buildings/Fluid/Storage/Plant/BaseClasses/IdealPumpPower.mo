within Buildings.Fluid.Storage.Plant.BaseClasses;
model IdealPumpPower "Estimates the pump power consumption in IdealConnection"

  parameter Modelica.Units.SI.Efficiency eta=0.49 "Constant efficiency";

  Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput dpMachine "Pressure rise" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Divide volFloRat
    "Converts mass flow rate to volumetric flow rate"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant rho(final k=1000)
    "Constant density for water"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide divByEff
    "Divide flow work by efficiency"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant conEff(final k=eta) "Constant efficiency"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity="Power",
    final unit="W") "Estimated power consumption"
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter limFlo(
    final uMax=Modelica.Constants.inf,
    final uMin=0) "Limit flow rate to be non-negative"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter limPre(
    final uMax=Modelica.Constants.inf,
    final uMin=0) "Limit pressure rise to be non-negative"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(rho.y, volFloRat.u2) annotation (Line(points={{-59,10},{-48,10},{-48,
          24},{-42,24}}, color={0,0,127}));
  connect(volFloRat.y, mul.u1) annotation (Line(points={{-18,30},{-8,30},{-8,-4},
          {-2,-4}}, color={0,0,127}));
  connect(conEff.y, divByEff.u2) annotation (Line(points={{21,-50},{32,-50},{32,
          -16},{38,-16}}, color={0,0,127}));
  connect(divByEff.y, PEle) annotation (Line(points={{62,-10},{94,-10},{94,0},{
          110,0}}, color={0,0,127}));
  connect(m_flow, limFlo.u)
    annotation (Line(points={{-110,40},{-82,40}}, color={0,0,127}));
  connect(limFlo.y, volFloRat.u1) annotation (Line(points={{-58,40},{-52,40},{
          -52,36},{-42,36}}, color={0,0,127}));
  connect(mul.u2, limPre.y) annotation (Line(points={{-2,-16},{-52,-16},{-52,
          -40},{-58,-40}}, color={0,0,127}));
  connect(limPre.u, dpMachine)
    annotation (Line(points={{-82,-40},{-110,-40}}, color={0,0,127}));
  connect(mul.y, divByEff.u1) annotation (Line(points={{22,-10},{30,-10},{30,-4},
          {38,-4}}, color={0,0,127}));
  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                             Text(
          extent={{-80,78},{78,-80}},
          textColor={28,108,200},
          textString="P"),
        Text(
          extent={{-94,-28},{-38,-48}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="dp"),
        Text(
          extent={{-94,52},{-38,32}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="m")}), Documentation(info="<html>
<p>
This block estimates the pump power consumption as
<i>P = V&#775;&nbsp;&Delta;p &frasl; &eta;</i>.
Both <i>V&#775;</i> and <i>&Delta;p</i> are individually bounded to be
non-negative.
</p>
</html>"));
end IdealPumpPower;
