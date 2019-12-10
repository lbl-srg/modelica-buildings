within Buildings.Controls.OBC.Utilities.Examples;
model OptimalStart
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Air
    "Medium model";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHea(k=21 + 273.15)
    annotation (Placement(transformation(extent={{-136,40},{-116,60}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(heating_only=true,
      cooling_only=false) "Heating only case"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15,
    m_flow_nominal=1,
    V=50*30*3) "Volume of air in the room" annotation (Placement(
        transformation(extent={{117,16},{137,36}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{36,-4},{16,16}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=-1, final k2=+1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    pre_y_start=false,
    uHigh=0,
    uLow=-60)
    "Hysteresis to activate the cool-down model"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Math.Gain PHea(k=700)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  HeatTransfer.Sources.PrescribedHeatFlow QHea
    annotation (Placement(transformation(extent={{82,40},{102,60}})));
  CDL.Continuous.Sources.Sine DelT(
    amplitude=-2,
    freqHz=1/100000,
    startTime(displayUnit="h"))     "Zone temperature for heating case"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));
  HeatTransfer.Sources.PrescribedHeatFlow QLos
    annotation (Placement(transformation(extent={{82,74},{102,94}})));
  Modelica.Blocks.Math.Gain UA(k=200)
    annotation (Placement(transformation(extent={{40,74},{60,94}})));
equation
  connect(TAir.port,rooVol. heatPort) annotation (Line(points={{36,6},{106,6},
          {106,26},{117,26}},color={191,0,0}));
  connect(TAir.T, optStaHea.TZon) annotation (Line(points={{16,6},{-110,6},{
          -110,30},{-102,30}},
                          color={0,0,127}));
  connect(occSch.tNexOcc, add1.u1) annotation (Line(points={{-79,76},{-66,76},
          {-66,56},{-62,56}},
                         color={0,0,127}));
  connect(optStaHea.tOpt, add1.u2) annotation (Line(points={{-78,30},{-66,30},{
          -66,44},{-62,44}},
                         color={0,0,127}));
  connect(add1.y, hys1.u) annotation (Line(points={{-38,50},{-32,50}}, color={0,0,127}));
  connect(hys1.y, booToRea.u)  annotation (Line(points={{-8,50},{-2,50}}, color={255,0,255}));
  connect(TSetHea.y, optStaHea.TSetZonHea) annotation (Line(points={{-114,50},
          {-110,50},{-110,38},{-102,38}},
                                    color={0,0,127}));
  connect(booToRea.y,PHea. u)  annotation (Line(points={{22,50},{38,50}}, color={0,0,127}));
  connect(PHea.y, QHea.Q_flow)  annotation (Line(points={{61,50},{82,50}}, color={0,0,127}));
  connect(QHea.port, rooVol.heatPort) annotation (Line(points={{102,50},{106,
          50},{106,26},{117,26}},
                            color={191,0,0}));
  connect(DelT.y, UA.u)
    annotation (Line(points={{22,84},{38,84}}, color={0,0,127}));
  connect(UA.y, QLos.Q_flow)
    annotation (Line(points={{61,84},{82,84}}, color={0,0,127}));
  connect(QLos.port, rooVol.heatPort) annotation (Line(points={{102,84},{106,
          84},{106,26},{117,26}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(StopTime=604800));
end OptimalStart;
