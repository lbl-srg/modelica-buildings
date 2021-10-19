within Buildings.Templates.TerminalUnits;
model VAVBox "VAV terminal unit"
  extends Buildings.Templates.TerminalUnits.Interfaces.SubSystemAir(
    final typ=Types.Configuration.SingleDuct);

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

  inner replaceable Templates.BaseClasses.Coils.None coiReh
    constrainedby Templates.Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumHea)
    "Reheat coil"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Coils.None coiReh "No coil"),
        choice(redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiReh "Water-based")),
      Dialog(group="Reheat coil"),
      Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable
    .Buildings.Templates.BaseClasses.Dampers.PressureIndependent damVAV
    constrainedby Buildings.Templates.Interfaces.Damper(redeclare final package
      Medium = MediumAir, final loc=Templates.Types.Location.Terminal)
    "VAV damper" annotation (Dialog(group="VAV damper"), Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-200})));

  inner replaceable Controls.OpenLoop conTer constrainedby
    Buildings.Templates.TerminalUnits.Interfaces.Controller
    "Terminal unit controller"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Controller"),
      Placement(transformation(extent={{-10,90},{10,110}})));

  .Buildings.Templates.BaseClasses.Sensors.Temperature TDis(
    redeclare final package Medium = MediumAir,
    final have_sen=conTer.typ == Types.Controller.Guideline36,
    final loc=Templates.Types.Location.Terminal)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{90,-210},{110,-190}})));
equation
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{-20,-280},
          {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{4,-210},{
          4,-220},{20,-220},{20,-280}},
                                      color={0,127,255}));
  connect(coiReh.busCon, busTer) annotation (Line(
      points={{0,-190},{0,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(port_Sup, damVAV.port_a)
    annotation (Line(points={{-300,-200},{-130,-200}}, color={0,127,255}));
  connect(damVAV.port_b, coiReh.port_a)
    annotation (Line(points={{-110,-200},{-10,-200}}, color={0,127,255}));
  connect(damVAV.busCon, busTer) annotation (Line(
      points={{-120,-190},{-120,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer, conTer.busTer) annotation (Line(
      points={{-300,0},{-20,0},{-20,100},{-10,100}},
      color={255,204,51},
      thickness=0.5));
  connect(coiReh.port_b, TDis.port_a)
    annotation (Line(points={{10,-200},{90,-200}}, color={0,127,255}));
  connect(TDis.port_b, port_Dis)
    annotation (Line(points={{110,-200},{300,-200}}, color={0,127,255}));
  connect(TDis.y, busTer.inp.TDis) annotation (Line(points={{100,-188},{100,0},
          {-300.1,0},{-300.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end VAVBox;
