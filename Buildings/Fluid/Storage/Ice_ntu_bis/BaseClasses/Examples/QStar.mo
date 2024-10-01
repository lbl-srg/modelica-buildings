within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.Examples;
model QStar "Example to calculate QStar"
  extends Modelica.Icons.Example;

  parameter Real coeCha[6] = {0, 0.09, -0.15, 0.612, -0.324, -0.216} "Coefficient for charging curve";
  parameter Real dt = 3600 "Time step used in the samples for curve fitting";

  Modelica.Blocks.Sources.Cosine fra(
    amplitude=0.5,
    f=1/86400,
    offset=0.5) "Fraction of charge"
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Modelica.Blocks.Sources.Constant lmtd(k=1) "Log mean temperature difference"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.QStar qSta(coeff=coeCha, dt=
        dt) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Logical.Sources.Constant active(k=true)
    "Outputs true to activate the component"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(fra.y, qSta.x) annotation (Line(points={{-39,4},{-26,4},{-26,0},{-12,
          0}}, color={0,0,127}));
  connect(lmtd.y, qSta.lmtdSta) annotation (Line(points={{-39,-30},{-26,-30},{
          -26,-6},{-12,-6}},
                         color={0,0,127}));
  connect(active.y, qSta.active) annotation (Line(points={{-38,40},{-20,40},{
          -20,6},{-12,6}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StartTime=0,
              StopTime=86400,
              Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/BaseClasses/Examples/QStar.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the
<a href=\"modelica://Buildings.Fluid.Storage.Ice.BaseClasses.QStar\">
Buildings.Fluid.Storage.Ice.BaseClasses.QStar</a>.
</p>
</html>", revisions="<html>
  <ul>
  <li>
  December 8, 2021, by Yangyang Fu:<br/>
  First implementation.
  </li>
  </ul>
</html>"));
end QStar;
