within Buildings.Experimental.Templates.AHUs.Interfaces;
partial model Main "Main interface class"
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)";
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)";

  constant Types.Main typ
    "Type of system"
    annotation (Evaluate=true,
      Dialog(group="Configuration"));
  constant Types.Supply typSup "Type of supply branch"
    annotation (Evaluate=true,
      Dialog(group="Configuration", enable=typ <> Types.Main.ExhaustOnly));
  constant Types.Return typRet "Type of return branch"
    annotation (Evaluate=true,
      Dialog(group="Configuration", enable=typ <> Types.Main.SupplyOnly));

  parameter String id=""
    "System identifier";

  parameter Integer nTer = 0
    "Number of terminal units served by the AHU";

  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare package Medium = MediumAir) if typ <> Types.Main.ExhaustOnly
    "Outdoor air intake"
    annotation (Placement(transformation(
          extent={{-310,-210},{-290,-190}}), iconTransformation(extent={{-210,
            -110},{-190,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
    redeclare package Medium =MediumAir) if
    typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.SingleDuct
    "Supply air" annotation (
      Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{190,-110},{210,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_SupCol(
    redeclare package Medium =MediumAir) if
    typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.DualDuct
    "Dual duct cold deck air supply"
    annotation (Placement(transformation(
          extent={{290,-250},{310,-230}}), iconTransformation(extent={{190,
            -180},{210,-160}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_SupHot(
    redeclare package Medium =MediumAir) if
    typ <> Types.Main.ExhaustOnly and typSup == Types.Supply.DualDuct
    "Dual duct hot deck air supply"
    annotation (Placement(
        transformation(extent={{290,-170},{310,-150}}), iconTransformation(
          extent={{190,-40},{210,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare package Medium =MediumAir) if
    typ <> Types.Main.SupplyOnly
    "Return air"
    annotation (Placement(transformation(extent={{290,-90},{310,-70}}),
        iconTransformation(extent={{190,90},{210,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Exh(
    redeclare package Medium = MediumAir) if
    typ == Types.Main.ExhaustOnly or
    (typ == Types.Main.SupplyReturn and typRet == Types.Return.WithRelief)
    "Exhaust/relief air"
    annotation (Placement(transformation(
          extent={{-310,-90},{-290,-70}}), iconTransformation(extent={{-210,90},
            {-190,110}})));

  Templates.BaseClasses.TerminalBus terBus[nTer]
    "Terminal unit control bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={198,160})));
  Templates.BaseClasses.AhuBus ahuBus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,0}),   iconTransformation(extent={{-20,-19},{20,19}},
        rotation=90,
        origin={-199,160})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}), graphics={
        Text(
          extent={{-155,-218},{145,-258}},
          lineColor={0,0,255},
          textString="%name"), Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,
            280}}), graphics={
        Rectangle(
          extent={{-300,40},{300,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={245,239,184},
          pattern=LinePattern.None)}));
end Main;
