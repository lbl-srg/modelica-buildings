within Buildings.Examples.VAVReheat.BaseClasses.Controls.Examples;
model RoomVAV "Test model for the room VAV controller"
  extends Modelica.Icons.Example;

  Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV boxWitExpDam(
    have_preIndDam=false,
    ratVFloMin=0.15,
    ratVFloHea=0.3,
    V_flow_nominal=1.5)
    "VAV terminal unit single maximum controller, for units with the exponential damper"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSet(k=273.15 + 21)
    "Heating setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSet(k=273.15 + 22)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=4,
    duration=3600,
    offset=-4) "Ramp source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=1,
    freqHz=1/3600,
    offset=273.15 + 23.5) "Sine source"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add rooTem "Room temperature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine disFlo(
    amplitude=0.1,
    freqHz=1/3600,
    offset=0.2) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-40,-78},{-20,-58}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV boxWitPreIndDam(
    have_preIndDam=true,
    ratVFloMin=0.15,
    ratVFloHea=0.3,
    V_flow_nominal=1.5)
    "VAV terminal unit single maximum controller, for units with the pressure independent damper"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  connect(rooTem.y, boxWitExpDam.TRoo) annotation (Line(points={{2,-20},{28,-20},
          {28,27},{58,27}}, color={0,0,127}));
  connect(cooSet.y, boxWitExpDam.TRooCooSet) annotation (Line(points={{-18,30},
          {34,30},{34,33},{58,33}}, color={0,0,127}));
  connect(heaSet.y, boxWitExpDam.TRooHeaSet) annotation (Line(points={{-18,70},
          {40,70},{40,38},{58,38}}, color={0,0,127}));
  connect(sin.y, rooTem.u2) annotation (Line(points={{-58,-40},{-40,-40},{-40,-26},
          {-22,-26}}, color={0,0,127}));
  connect(ram.y, rooTem.u1) annotation (Line(points={{-58,0},{-40,0},{-40,-14},{
          -22,-14}},  color={0,0,127}));

  connect(disFlo.y, boxWitExpDam.VDis_flow) annotation (Line(points={{-18,-68},
          {20,-68},{20,22},{58,22}}, color={0,0,127}));
  connect(heaSet.y, boxWitPreIndDam.TRooHeaSet) annotation (Line(points={{-18,
          70},{40,70},{40,-22},{58,-22}}, color={0,0,127}));
  connect(cooSet.y, boxWitPreIndDam.TRooCooSet) annotation (Line(points={{-18,
          30},{34,30},{34,-27},{58,-27}}, color={0,0,127}));
  connect(rooTem.y, boxWitPreIndDam.TRoo) annotation (Line(points={{2,-20},{28,
          -20},{28,-33},{58,-33}}, color={0,0,127}));
annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/BaseClasses/Controls/Examples/RoomVAV.mos"
        "Simulate and plot"),
    experiment(StopTime=3600, Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model tests the VAV box contoller of transition from heating control to cooling
control.
</p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RoomVAV;
