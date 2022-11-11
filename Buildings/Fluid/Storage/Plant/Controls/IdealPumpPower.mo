within Buildings.Fluid.Storage.Plant.Controls;
block IdealPumpPower
  "Estimates the pump power consumption in IdealConnection"
  extends Modelica.Blocks.Icons.Block;
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
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide volFloRat1
    "Converts mass flow rate to volumetric flow rate"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant eta(final k=0.49) "Constant efficiency"
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
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(uMax=Modelica.Constants.inf,
      uMin=0) annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(rho.y, volFloRat.u2) annotation (Line(points={{-59,-10},{-52,-10},{
          -52,24},{-42,24}},
                         color={0,0,127}));
  connect(m_flow, volFloRat.u1) annotation (Line(points={{-110,40},{-52,40},{
          -52,36},{-42,36}},
                         color={0,0,127}));
  connect(volFloRat.y, mul.u1) annotation (Line(points={{-18,30},{-12,30},{-12,
          6},{-44,6},{-44,-4},{-42,-4}},
                    color={0,0,127}));
  connect(mul.u2, dpMachine) annotation (Line(points={{-42,-16},{-44,-16},{-44,
          -40},{-110,-40}},
                       color={0,0,127}));
  connect(eta.y, volFloRat1.u2) annotation (Line(points={{21,-50},{32,-50},{32,-16},
          {38,-16}}, color={0,0,127}));
  connect(volFloRat1.y, PEle) annotation (Line(points={{62,-10},{94,-10},{94,0},
          {110,0}}, color={0,0,127}));
  connect(mul.y, lim.u)
    annotation (Line(points={{-18,-10},{-2,-10}}, color={0,0,127}));
  connect(lim.y, volFloRat1.u1) annotation (Line(points={{22,-10},{30,-10},{30,
          -4},{38,-4}}, color={0,0,127}));
  annotation (Icon(graphics={Text(
          extent={{-80,78},{78,-80}},
          textColor={28,108,200},
          textString="P")}));
end IdealPumpPower;
