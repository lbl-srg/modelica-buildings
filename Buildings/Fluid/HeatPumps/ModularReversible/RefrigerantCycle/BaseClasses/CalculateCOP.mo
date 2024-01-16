within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
model CalculateCOP
  "Calculate the COP or EER of a device"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Power PEleMin(min=Modelica.Constants.eps)
    "If eletrical power consumption falls below this value, COP will be set to zero";

  Modelica.Blocks.Interfaces.RealInput PEle(final unit="W", displayUnit="W")
    "Electrical power consumed by the system" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(extent=
           {{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput QUse_flow(final unit="W", displayUnit="W")
    "Useful heat flow" annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));
  Modelica.Blocks.Interfaces.RealOutput COP(min=0, final unit="1")
                                            "Output for calculated COP value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    uLow=PEleMin,
    uHigh=PEleMin*1.1)
    "Hysteresis to switch between calculation and no calculation"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
protected
  Modelica.Blocks.Math.Division copCom "Computes COP"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Logical.Switch swi
    "Outputs COP or zero depending on electricity use"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Switch swiDivZer
    "Outputs COP or zero depending on electricity use"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.Constant one(final k=1)
    "Outputs one to avoid division by zero"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
initial equation
  assert(PEleMin > 0,
    "In " + getInstanceName() + ": PEleMin must be greater than zero. Disable efficiency calculation using
    calEff=false to debug why PEle_nominal is lower than zero.",
    AssertionLevel.error);

equation

  connect(hys.u, PEle)
    annotation (Line(points={{-62,-40},{-120,-40}}, color={0,0,127}));
  connect(QUse_flow, copCom.u1) annotation (Line(points={{-120,40},{-80,40},{-80,
          56},{18,56}},  color={0,0,127}));
  connect(swi.y, COP)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{-39,-40},{0,-40},{0,0},{58,0}},
        color={255,0,255}));
  connect(copCom.y, swi.u1)
    annotation (Line(points={{41,50},{48,50},{48,8},{58,8}},color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{41,-30},{50,-30},{50,-8},{58,
          -8}}, color={0,0,127}));
  connect(swiDivZer.u1, PEle) annotation (Line(points={{-22,28},{-80,28},{-80,-40},
          {-120,-40}}, color={0,0,127}));
  connect(swiDivZer.u2, hys.y) annotation (Line(points={{-22,20},{-30,20},{-30,-40},
          {-39,-40}}, color={255,0,255}));
  connect(copCom.u2, swiDivZer.y)
    annotation (Line(points={{18,44},{8,44},{8,20},{1,20}}, color={0,0,127}));
  connect(one.y, swiDivZer.u3) annotation (Line(points={{-39,10},{-32,10},{-32,12},
          {-22,12}}, color={0,0,127}));
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
end CalculateCOP;
