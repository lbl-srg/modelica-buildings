within Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses_save.Examples;
model NormalizedHeatFlowRate "Example to calculate qStar"
  extends Modelica.Icons.Example;
  parameter Real coeCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for charging curve";
  parameter Real coeDisCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for discharging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    offset=0.5,
    f=1/7200) "Fraction of charge"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Storage.Ice_ntu_ini.BaseClasses_save.NormalizedHeatFlowRate norQSta(
    coeCha=coeCha,
    dtCha=dt,
    coeDisCha=coeDisCha,
    dtDisCha=dt) "Storage heat transfer rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Blocks.Sources.Step lmtd(
    startTime=3600,
    offset=1,
    height=-0.5)
               "lmtd start"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.75)
    "Switch the change between charging and discharging mode"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,2},{40,22}})));
equation
  connect(fra.y, norQSta.SOC)
    annotation (Line(points={{-19,0},{58,0}}, color={0,0,127}));
  connect(lmtd.y, norQSta.lmtdSta) annotation (Line(points={{-19,-50},{-14,-50},
          {-14,-6},{58,-6}},
                           color={0,0,127}));
  connect(lmtd.y, greThr.u) annotation (Line(points={{-19,-50},{-14,-50},{-14,
          40},{-12,40}}, color={0,0,127}));
  connect(norQSta.canMelt, greThr.y) annotation (Line(points={{58,8},{50,8},{50,
          40},{12,40}}, color={255,0,255}));
  connect(greThr.y, not1.u) annotation (Line(points={{12,40},{16,40},{16,12},{
          18,12}}, color={255,0,255}));
  connect(not1.y, norQSta.canFreeze) annotation (Line(points={{42,12},{46,12},{
          46,4},{58,4}}, color={255,0,255}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/BaseClasses/Examples/NormalizedHeatFlowRate.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
  </html>",
info="<html>
<p>
This example is to validate the
<a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.NormalizedHeatFlowRate\">
Buildings.Fluid.Storage.Ice.BaseClasses.NormalizedHeatFlowRate</a>.
</p>
</html>"));
end NormalizedHeatFlowRate;
