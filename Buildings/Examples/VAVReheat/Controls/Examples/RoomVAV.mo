within Buildings.Examples.VAVReheat.Controls.Examples;
model RoomVAV "Test model for the room VAV controller"
  extends Modelica.Icons.Example;
  RoomVAV_new roomVAV_new(
    V_flow_nominal=1,
    VCooMax_flow=1.25,
    minFloRat=0.4)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSet(k=273.15 + 21)
    "Heating setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSet(k=273.15 + 22)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=4,
    duration=3600,
    offset=-4)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=1,
    freqHz=1/3600,
    offset=273.15 + 23.5)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(add2.y, roomVAV_new.TRoo) annotation (Line(points={{2,-50},{20,-50},{
          20,-7},{39,-7}}, color={0,0,127}));
  connect(cooSet.y, roomVAV_new.TRooCooSet)
    annotation (Line(points={{-18,20},{0,20},{0,0},{38,0}}, color={0,0,127}));
  connect(heaSet.y, roomVAV_new.TRooHeaSet) annotation (Line(points={{-18,70},{
          20,70},{20,7},{38,7}}, color={0,0,127}));
  connect(sin.y, add2.u2) annotation (Line(points={{-58,-70},{-40,-70},{-40,-56},
          {-22,-56}}, color={0,0,127}));
  connect(ram.y, add2.u1) annotation (Line(points={{-58,-30},{-40,-30},{-40,-44},
          {-22,-44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
end RoomVAV;
