within Buildings.Templates.TerminalUnits;
model VAVReheat "VAV terminal unit with reheat"
  extends Buildings.Templates.Interfaces.TerminalUnitAir(
    final typ=Types.TerminalUnit.SingleDuct);

  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHea or have_souCoiReh));

  final parameter Boolean have_souCoiReh=coiReh.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  Modelica.Fluid.Interfaces.FluidPort_a port_coiRehSup(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil supply port"
    annotation (Placement(transformation(extent={{-30,-290},{-10,-270}}),
                                iconTransformation(extent={{-30,-208},{-10,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiRehRet(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil return port"
    annotation (Placement(transformation(extent={{10,-290},{30,-270}}),
                          iconTransformation(extent={{10,-208},{30,-188}})));

  inner replaceable BaseClasses.Coils.None coiReh
    constrainedby Buildings.Templates.Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumHea)
    "Reheat coil"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Reheat coil"),
    Placement(transformation(extent={{-10,-150},{10,-130}})));

  inner replaceable BaseClasses.Dampers.None damVAV constrainedby
    Buildings.Templates.Interfaces.Damper(
      redeclare final package Medium = MediumAir)
    "VAV damper" annotation (
    choices(
      choice(redeclare BaseClasses.Dampers.None damVAV "No damper"),
      choice(redeclare BaseClasses.Dampers.PressureIndependent damVAV "Pressure independent damper")),
    Dialog(group="VAV damper"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-140})));

  inner replaceable Controls.OpenLoop conTer constrainedby
    Buildings.Templates.Interfaces.ControllerTerminalUnit
    "Terminal unit controller" annotation (
    choicesAllMatching=true,
    Dialog(group="Controller"),
    Placement(transformation(extent={{-10,90},{10,110}})));

  replaceable BaseClasses.Sensors.None TDis constrainedby
    Buildings.Templates.Interfaces.Sensor(
      redeclare final package Medium = MediumAir)
    "Discharge air temperature sensor"
    annotation (
      choices(
        choice(redeclare BaseClasses.Sensors.None TDis "No sensor"),
        choice(redeclare BaseClasses.Sensors.Temperature TDis "Temperature sensor")),
      Dialog(group="Reheat coil"),
      Placement(transformation(extent={{90,-150},{110,-130}})));
equation
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{-20,-280},
          {-20,-160},{-4,-160},{-4,-150}}, color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{4,-150},{4,
          -160},{20,-160},{20,-280}}, color={0,127,255}));
  connect(coiReh.busCon, busTer) annotation (Line(
      points={{0,-130},{0,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(port_Sup, damVAV.port_a)
    annotation (Line(points={{-300,-140},{-130,-140}}, color={0,127,255}));
  connect(damVAV.port_b, coiReh.port_a)
    annotation (Line(points={{-110,-140},{-10,-140}}, color={0,127,255}));
  connect(damVAV.busCon, busTer) annotation (Line(
      points={{-120,-130},{-120,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer, conTer.busTer) annotation (Line(
      points={{-300,0},{-20,0},{-20,100},{-10,100}},
      color={255,204,51},
      thickness=0.5));
  connect(coiReh.port_b,TDis. port_a)
    annotation (Line(points={{10,-140},{90,-140}}, color={0,127,255}));
  connect(TDis.port_b, port_Dis)
    annotation (Line(points={{110,-140},{300,-140}}, color={0,127,255}));
  connect(TDis.busCon, busTer) annotation (Line(
      points={{100,-130},{100,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
end VAVReheat;
