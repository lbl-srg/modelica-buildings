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
      conPumVal(final plaTyp=nom.plaTyp));

equation
  connect(tanBra.mTanBot_flow,conPumVal. mTanBot_flow)
    annotation (Line(points={{-14,11},{-14,50},{9,50}}, color={0,0,127}));
  connect(netCon.ySup_actual,conPumVal. ySup_actual) annotation (Line(points={{14,11},
          {14,34},{4,34},{4,42},{9,42}},        color={0,0,127}));
  connect(conPumVal.yPumSup,netCon.yPumSup)
    annotation (Line(points={{18,39},{18,11}}, color={0,0,127}));
  connect(conPumVal.yValSup,netCon.yValSup)
    annotation (Line(points={{22,39},{22,11}}, color={0,0,127}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
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
