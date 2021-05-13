within Buildings.ThermalZones.EnergyPlus.Validation.ZoneSurface;
model OneZoneControlledFloorTemperature
  "Validation model with one thermal zone with controlled floor temperature"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus.ZoneSurface flo(
    surfaceName="Living:Floor")
    "Floor surface of living room"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHea(
    k(
      final unit="K",
      displayUnit="degC")=293.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Room temperture set point for heating"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.CDL.Continuous.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.25,
    Ti(
      displayUnit="min")=1800)
    "Controller for heating"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCoo(
    k(
      final unit="K",
      displayUnit="degC")=297.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Room temperture set point for cooling"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Controls.OBC.CDL.Continuous.PID conCoo(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.25,
    Ti(
      displayUnit="min")=1800,
    reverseActing=false)
    "Controller for cooling"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Controls.OBC.CDL.Continuous.Add dTSetFlo(
    k1=-5,
    k2=5)
    "Change in floor temperature compared to room air temperature"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Controls.OBC.CDL.Continuous.Add TFlo(
    y(
      final unit="K",
      displayUnit="degC"))
    "Floor temperature"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

equation
  connect(conHea.u_s,TSetRooHea.y)
    annotation (Line(points={{-42,50},{-58,50}},color={0,0,127}));
  connect(zon.TAir,conHea.u_m)
    annotation (Line(points={{41,18},{52,18},{52,30},{-30,30},{-30,38}},color={0,0,127}));
  connect(TSetRooCoo.y,conCoo.u_s)
    annotation (Line(points={{-58,80},{-42,80}},color={0,0,127}));
  connect(conCoo.u_m,zon.TAir)
    annotation (Line(points={{-30,68},{-30,66},{-46,66},{-46,30},{52,30},{52,18},{41,18}},color={0,0,127}));
  connect(conCoo.y,dTSetFlo.u1)
    annotation (Line(points={{-18,80},{-10,80},{-10,76},{-2,76}},color={0,0,127}));
  connect(conHea.y,dTSetFlo.u2)
    annotation (Line(points={{-18,50},{-10,50},{-10,64},{-2,64}},color={0,0,127}));
  connect(zon.TAir,TFlo.u2)
    annotation (Line(points={{41,18},{52,18},{52,34},{24,34},{24,44},{28,44}},color={0,0,127}));
  connect(dTSetFlo.y,TFlo.u1)
    annotation (Line(points={{22,70},{26,70},{26,56},{28,56}},color={0,0,127}));
  connect(TFlo.y,flo.T)
    annotation (Line(points={{52,50},{68,50}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ZoneSurface/OneZoneControlledFloorTemperature.mos" "Simulate and plot"),
    experiment(
      StartTime=10800000,
      StopTime=11232000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus and controls the floor temperature to a track a heating and cooling set point.
</p>
<p>
The model has two PI controllers, one for tracking the heating and and for tracking the cooling set point temperature.
The model sets the surface temperature of the floor to provide heating or cooling if either control signal is non-zero.
Note that this model assumes that the surface temperature can be perfectly controlled.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 12, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneZoneControlledFloorTemperature;
