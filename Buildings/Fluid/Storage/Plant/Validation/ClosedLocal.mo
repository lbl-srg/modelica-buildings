within Buildings.Fluid.Storage.Plant.Validation;
model ClosedLocal
  "Validation model of a storage plant with a closed tank and NO remote charging ability"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    nom(
      plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal),
    netCon(pumSup(y_start=0.707)));
  Modelica.Blocks.Sources.TimeTable mSet_flow(table=[0,0; 900,0; 900,1; 1800,1;
        1800,0; 2700,0; 2700,1; 3600,1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.Continuous.LimPID conPID_PumSec(k=0.5, Ti=15)
           "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,90})));
  Modelica.Blocks.Math.Gain gai(k=1/nom.m_flow_nominal)       "Gain"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-50,60})));
equation
  connect(netCon.port_bToChi, senMasFlo.port_a) annotation (Line(points={{0,-6},{
          -70,-6},{-70,30},{-60,30}},  color={0,127,255}));
  connect(gai.y,conPID_PumSec. u_m)
    annotation (Line(points={{-50,71},{-50,78}},  color={0,0,127}));
  connect(mSet_flow.y, conPID_PumSec.u_s)
    annotation (Line(points={{-79,90},{-62,90}}, color={0,0,127}));
  connect(gai.u, senMasFlo.m_flow)
    annotation (Line(points={{-50,48},{-50,41}}, color={0,0,127}));
  connect(netCon.yPumSup, conPID_PumSec.y)
    annotation (Line(points={{8,11},{8,90},{-39,90}}, color={0,0,127}));
annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedLocal.mos"
        "Simulate and plot"),
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
[]
</html>", revisions="<html>
<ul>
<li>
September 20, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ClosedLocal;
