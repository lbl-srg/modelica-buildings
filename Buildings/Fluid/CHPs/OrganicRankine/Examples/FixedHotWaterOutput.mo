within Buildings.Fluid.CHPs.OrganicRankine.Examples;
model FixedHotWaterOutput
  "Example model with fixed hot water output temperature at condenser"
  extends Buildings.Fluid.CHPs.OrganicRankine.Validation.VaryingHot(
    souCol(
      use_m_flow_in=true,
      T=298.15));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=mCol_flow_nominal)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Sources.Constant TWatOut_set(k=40 + 273.15)
    "Set point of hot water output"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant mCol_flow_min(k=mCol_flow_nominal*0.2)
    "Minimum condenser cold fluid flow rate"
    annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
equation
  connect(conPID.y, gai.u)
    annotation (Line(points={{-19,-70},{-2,-70}}, color={0,0,127}));
  connect(gai.y, max1.u2) annotation (Line(points={{22,-70},{30,-70},{30,-66},{38,
          -66}}, color={0,0,127}));
  connect(max1.y, souCol.m_flow_in) annotation (Line(points={{62,-60},{70,-60},{
          70,-22},{42,-22}}, color={0,0,127}));
  connect(TWatOut_set.y, conPID.u_s)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
  connect(TColOut.T, conPID.u_m) annotation (Line(points={{-40,-19},{-40,-14},{-88,
          -14},{-88,-92},{-30,-92},{-30,-82}}, color={0,0,127}));
  connect(mCol_flow_min.y, max1.u1) annotation (Line(points={{9,-40},{16,-40},{16,
          -54},{38,-54}}, color={0,0,127}));
annotation(experiment(StopTime=300,Tolerance=1E-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/Examples/FixedHotWaterOutput.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
In this example model, the cooling water flow rate is controlled via
a feedback loop that maintains a fixed temperature of water coming out of
the condenser, unless when the heat flow from the waste heat stream is
too little. In the latter case, this temperature set point is not met,
because a minimum cooling fluid flow rate must be maintained at all times
when the cycle is on.
</p>
</html>",revisions="<html>
<ul>
<li>
February 21, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end FixedHotWaterOutput;
