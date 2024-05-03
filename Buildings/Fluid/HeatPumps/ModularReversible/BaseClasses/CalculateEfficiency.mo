within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
model CalculateEfficiency
  "Calculate the COP or EER of a device"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Power PEleMin(min=Modelica.Constants.eps)
    "If eletrical power consumption falls below this value, COP will be set to zero";

  Modelica.Blocks.Interfaces.RealInput PEle(final unit="W", displayUnit="W")
    "Electrical power consumed by the system" annotation (Placement(
        transformation(extent={{-140,-90},{-100,-50}}), iconTransformation(extent={{-140,
            -90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput QUse_flow(final unit="W", displayUnit="W")
    "Useful heat flow" annotation (Placement(transformation(
          extent={{-140,50},{-100,90}}), iconTransformation(extent={{-140,50},{-100,
            90}})));
  Modelica.Blocks.Interfaces.RealOutput COP(min=0, final unit="1")
    "Output for calculated COP value"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    uLow=PEleMin,
    uHigh=PEleMin*1.1)
    "Hysteresis to switch between calculation and no calculation"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Interfaces.BooleanInput hea
    "=true for heating, false for cooling" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Modelica.Blocks.Interfaces.RealOutput EER(min=0, final unit="1")
    "Output for calculated EER value"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Math.InverseXRegularized invXReg(delta=PEleMin)
    "Inverse of electrical power"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
protected
  Modelica.Blocks.Math.Product  copCom "Computes COP"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Logical.Switch swi
    "Outputs COP or zero depending on electricity use"
    annotation (Placement(transformation(extent={{-4,-50},{16,-30}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Logical.Switch swiCoo "Switch for cooling and EER calculation"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Logical.Switch swiHea "Switch for heating and COP calculation"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
protected
  Modelica.Blocks.Math.Abs absQEva_flow
    "Negates possibly negative usefule flow rates"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
initial equation
  assert(PEleMin > 0,
    "In " + getInstanceName() + ": PEleMin must be greater than zero. Disable efficiency calculation using
    calEff=false to debug why PEle_nominal is lower than zero.",
    AssertionLevel.error);

equation

  connect(hys.u, PEle)
    annotation (Line(points={{-62,-40},{-80,-40},{-80,-70},{-120,-70}},
                                                    color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{-39,-40},{-6,-40}},
        color={255,0,255}));
  connect(copCom.y, swi.u1)
    annotation (Line(points={{21,50},{34,50},{34,-20},{-20,-20},{-20,-32},{-6,
          -32}},                                            color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-19,-70},{-14,-70},{-14,-48},{-6,
          -48}},color={0,0,127}));
  connect(swiCoo.y, EER)
    annotation (Line(points={{81,-60},{110,-60}}, color={0,0,127}));
  connect(swiHea.y, COP) annotation (Line(points={{81,60},{94,60},{94,60},{110,60}},
        color={0,0,127}));
  connect(hea, swiHea.u2) annotation (Line(points={{-120,0},{-90,0},{-90,92},{
          40,92},{40,60},{58,60}},
                            color={255,0,255}));
  connect(swi.y, swiHea.u1) annotation (Line(points={{17,-40},{44,-40},{44,68},{58,
          68}}, color={0,0,127}));
  connect(swiHea.u3, zer.y) annotation (Line(points={{58,52},{48,52},{48,-70},{-19,
          -70}}, color={0,0,127}));
  connect(hea, swiCoo.u2) annotation (Line(points={{-120,0},{-90,0},{-90,-90},{40,
          -90},{40,-60},{58,-60}}, color={255,0,255}));
  connect(swi.y, swiCoo.u3) annotation (Line(points={{17,-40},{44,-40},{44,-68},
          {58,-68}},
                 color={0,0,127}));
  connect(zer.y, swiCoo.u1) annotation (Line(points={{-19,-70},{48,-70},{48,-52},{
          58,-52}}, color={0,0,127}));
  connect(QUse_flow, absQEva_flow.u) annotation (Line(points={{-120,70},{-42,70}},
                             color={0,0,127}));
  connect(absQEva_flow.y, copCom.u1) annotation (Line(points={{-19,70},{-12,70},
          {-12,56},{-2,56}},
                       color={0,0,127}));
  connect(copCom.u2, invXReg.y) annotation (Line(points={{-2,44},{-14,44},{-14,
          30},{-19,30}}, color={0,0,127}));
  connect(invXReg.u, PEle) annotation (Line(points={{-42,30},{-80,30},{-80,-70},
          {-120,-70}},                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
  <li>
    December 7, 2023, by Michael Wetter:<br/>
    Reformulated to avoid mixing text and connect statements.
  </li>
  <li>
    <i>November 26, 2018,</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model is used to calculate the COP or the EER of a device. As
  the electrical power can get zero, a lower boundary is used to
  avoid division by zero.
</p>
</html>"));
end CalculateEfficiency;
