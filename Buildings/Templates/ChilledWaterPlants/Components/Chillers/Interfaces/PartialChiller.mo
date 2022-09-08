within Buildings.Templates.ChilledWaterPlants.Components.Chillers.Interfaces;
partial model PartialChiller "Partial chiller model"
  extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
    redeclare replaceable package Medium1=Buildings.Media.Water,
    redeclare replaceable package Medium2=Buildings.Media.Water,
    final haveMedium1=true,
    final haveMedium2=not isAirCoo,
    final m1_flow_nominal=dat.m1_flow_nominal,
    final m2_flow_nominal=dat.m2_flow_nominal);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=not isAirCoo,
    final dp1_nominal=dat.dp1_nominal,
    final dp2_nominal=dat.dp2_nominal);

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlants.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Compressor typCom=
      Buildings.Templates.ChilledWaterPlants.Types.Compressor.ConstantSpeed
    "Type of compressor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  // fixme: Figure out what this entails with existing chiller class
  parameter Boolean is_heaPreCon = false
    "Set to true if chiller is controlled with head pressure";
  parameter Boolean have_heaPreSig = false
    "Set to true if chiller has a head pressure signal"
    annotation(Dialog(enable=is_heaPreCon));
  parameter Boolean have_TChiWatChiRet = true
    "Set to true if chiller chilled water return temperature is measured"
    annotation(Dialog(enable=not is_heaPreCon or have_heaPreSig));
  parameter Boolean have_TConWatChiSup = true
    "Set to true if chiller condenser water supply temperature is measured"
    annotation(Dialog(enable=not is_heaPreCon or have_heaPreSig));

  // Record

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Chillers dat(
    final typ=typ,
    final isAirCoo=isAirCoo,
    final is_heaPreCon=is_heaPreCon,
    final have_heaPreSig=have_heaPreSig,
    final have_TChiWatChiSup=have_TChiWatChiSup,
    final have_TConWatChiRet=have_TConWatChiRet) "Chiller data";

  Buildings.Templates.Components.Sensors.Temperature TChiWatChiRet(
    redeclare final package Medium = Medium2,
    final have_sen=have_TChiWatChiRet,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m2_flow_nominal)
    "Chiller chilled water return temperature"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiSup(
    redeclare final package Medium = Medium2,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m2_flow_nominal)
    "Chiller chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatChiSup(
    redeclare final package Medium = Medium1,
    final have_sen=have_TConWatChiSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m1_flow_nominal)
    "Chiller condenser water supply temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatChiRet(
    redeclare final package Medium = Medium1,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m1_flow_nominal)
    "Chiller condenser water return temperature"
    annotation (Placement(transformation(extent={{58,50},{78,70}})));

  Buildings.Templates.Components.Interfaces.Bus bus "Control bus" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

equation

  // Sensors

  connect(bus.TConWatChiSup, TConWatChiSup.y)
    annotation (Line(points={{0,100},{0,80},{-70,80},{-70,72}},
      color={0,0,127}));
  connect(bus.TConWatChiRet, TConWatChiRet.y)
    annotation (Line(points={{0,100},{0,80},{68,80},{68,72}},
      color={0,0,127}));
  connect(bus.TChiWatChiSup, TChiWatChiSup.y)
    annotation (Line(points={{0,100},{0,80},{-88,80},{-88,-20},{-70,-20},{-70,-48}},
      color={0,0,127}));
  connect(bus.TChiWatChiRet, TChiWatChiRet.y)
    annotation (Line(
      points={{0,100},{0,80},{88,80},{88,-20},{70,-20},{70,-48}},
      color={0,0,127}));

  // Hydraulics

  connect(port_a1, TConWatChiSup.port_a)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(port_b1, TConWatChiRet.port_b)
    annotation (Line(points={{100,60},{78,60}}, color={0,127,255}));
  connect(port_a2, TChiWatChiRet.port_b)
    annotation (Line(points={{100,-60},{80,-60}}, color={0,127,255}));
  connect(port_b2, TChiWatChiSup.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChiller;
