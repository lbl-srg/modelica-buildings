within Buildings.Templates.TerminalUnits;
model VAVReheat "VAV terminal unit with reheat"
  extends Buildings.Templates.Interfaces.TerminalUnitAir(
    final typ=Types.TerminalUnit.SingleDuct)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

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
    BaseClasses.Dampers.None(redeclare final package Medium = MediumAir)
    "VAV damper" annotation (
    choices(
      choice(redeclare BaseClasses.Dampers.None damVAV "No damper"),
      choice(redeclare BaseClasses.Dampers.PressureIndependent damVAV "Pressure independent damper")),
    Dialog(group="Economizer"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-140})));

  Controls.Dummy conTer
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
equation
  connect(coiReh.port_b, port_Dis) annotation (Line(points={{10,-140},{300,-140}},
                                  color={0,127,255}));
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{-20,-280},
          {-20,-160},{-4,-160},{-4,-150}}, color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{4,-150},{4,
          -160},{20,-160},{20,-280}}, color={0,127,255}));
  connect(coiReh.busCon, busTer) annotation (Line(
      points={{0,-130},{0,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(port_Sup, damVAV.port_a)
    annotation (Line(points={{-300,-140},{-150,-140}}, color={0,127,255}));
  connect(damVAV.port_b, coiReh.port_a)
    annotation (Line(points={{-130,-140},{-10,-140}}, color={0,127,255}));
  connect(damVAV.busCon, busTer) annotation (Line(
      points={{-140,-130},{-140,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer, conTer.busTer) annotation (Line(
      points={{-300,0},{-20,0},{-20,100},{-10,100}},
      color={255,204,51},
      thickness=0.5));
end VAVReheat;
