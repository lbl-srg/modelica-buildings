within Buildings.Fluid.Storage.Plant.Validation;
model ClosedRemote
  "Validation model of a storage plant with a closed tank allowing remote charging"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    netCon(plaTyp=nom.plaTyp),
      nom(final plaTyp=
        Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote),
    tanBra(tankIsOpen=false));
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule(
      conRemCha(final plaTyp=nom.plaTyp));

  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=300000,
    final T=nom.T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-50})));
equation
  connect(conRemCha.yPumSup,netCon.yPumSup)
    annotation (Line(points={{18,39},{18,11}}, color={0,0,127}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(conRemCha.yValSup, netCon.yValSup)
    annotation (Line(points={{22,39},{22,11}}, color={0,0,127}));
  connect(tanBra.mTan_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-16,11},{-16,54},{9,54}}, color={0,0,127}));
  connect(sou_p.ports[1], tanBra.port_aFroNet) annotation (Line(points={{-20,
          -50},{0,-50},{0,-6},{-10,-6}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedRemote.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model where the storage plant with a closed tank is configured
to allow remotely charging the tank.
The operation modes are implemented in the time tables by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule\">
Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 21, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ClosedRemote;
