within Buildings.Fluid.Storage.Plant.Validation;
model Open "(Draft)"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    netCon(
      plaTyp=nom.plaTyp,
        pumSup(per(pressure(V_flow=nom.m_flow_nominal*{0,1.6,2},
                            dp=(sin.p-101325)*{2,1.6,0}))),
        pumRet(per(pressure(V_flow=nom.mTan_flow_nominal*{0,1.6,2},
                            dp=(sou.p-101325)*{2,1.6,0})))),
      nom(
        final plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open,
        final dp_nominal=300000),
    tanBra(tankIsOpen=true));
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule(
      conPumVal(final plaTyp=nom.plaTyp));

equation
  connect(tanBra.port_froNet, netCon.port_toChi)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(netCon.port_froChi, tanBra.port_toNet)
    annotation (Line(points={{10,6},{-10,6}}, color={0,127,255}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(conPumVal.mTanTop_flow, tanBra.mTanTop_flow)
    annotation (Line(points={{9,54},{-18,54},{-18,11}}, color={0,0,127}));
  connect(conPumVal.mTanBot_flow, tanBra.mTanBot_flow)
    annotation (Line(points={{9,50},{-12,50},{-12,11}}, color={0,0,127}));
  connect(conPumVal.yPumSup,netCon.yPumSup)
    annotation (Line(points={{18,39},{18,11}}, color={0,0,127}));
  connect(netCon.yValSup, conPumVal.yValSup)
    annotation (Line(points={{22,11},{22,39}}, color={0,0,127}));
  connect(conPumVal.yPumRet,netCon.yPumRet)
    annotation (Line(points={{26,39},{26,11}}, color={0,0,127}));
  connect(netCon.yRet, conPumVal.yRet) annotation (Line(points={{29.8,11},{29.8,
          10},{30,10},{30,39}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Open.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model where the storage plant has an open tank.
This configuration automatically allows charging the tank remotely.
The operation modes are implemented in the time tables by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule\">
Buildings.Fluid.Storage.Plant.Validation.BaseClasses.RemoteChargingSchedule</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end Open;
