within Buildings.Templates.Components;
package Interfaces "Base classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;

  partial model Actuator
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";

    parameter Buildings.Templates.Components.Types.Actuator typ
      "Equipment type" annotation (Evaluate=true, Dialog(group="Configuration"));

    outer parameter String funStr
      "String used to identify the coil function";
    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    outer parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
      "Liquid mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    outer parameter Modelica.SIunits.PressureDifference dpWat_nominal
      "Liquid pressure drop"
      annotation(Dialog(group = "Nominal condition"));

    Modelica.Fluid.Interfaces.FluidPort_a port_aSup(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{30,90},{50,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-30,90},{-50,110}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
      if typ <> Buildings.Templates.Components.Types.Actuator.None
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=0,   origin={-120,0}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,0})));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
          Text(
            extent={{-145,-116},{155,-156}},
            lineColor={0,0,255},
            textString="%name"),                                Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Actuator;

  partial model Coil
    extends Buildings.Fluid.Interfaces.PartialTwoPort(
      redeclare final package Medium=MediumAir);

    replaceable package MediumAir=Buildings.Media.Air
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Air medium";
    replaceable package MediumSou=Buildings.Media.Water
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Source side medium"
      annotation(Dialog(enable=have_sou));

    parameter Buildings.Templates.Components.Types.Coil typ "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.CoilFunction fun
      "Coil function" annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.Actuator typAct
      "Type of actuator" annotation (Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.HeatExchanger typHex
      "Type of heat exchanger" annotation (Dialog(group="Configuration"));
    parameter Boolean have_sou = false
      "Set to true for fluid ports on the source side"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Boolean have_weaBus = false
      "Set to true to use a waether bus"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";
    final inner parameter String funStr=
      if fun==Buildings.Templates.Components.Types.CoilFunction.Cooling
                                         then "Cooling"
      elseif fun==Buildings.Templates.Components.Types.CoilFunction.Heating
                                             then "Heating"
      elseif fun==Buildings.Templates.Components.Types.CoilFunction.Reheat
                                            then "Reheat"
      else "Undefined"
      "Coil function cast as string"
      annotation (
        Dialog(group="Configuration"),
        Evaluate=true);

    Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
      redeclare final package Medium = MediumSou) if have_sou
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
      redeclare final package Medium = MediumSou) if have_sou
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
    BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
      annotation (Placement(
          transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-70,90},
              {-50,110}})));
    Bus busCon if typ <> Buildings.Templates.Components.Types.Coil.None
      "Control bus"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={0,100}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,100})));

    annotation (Icon(
      coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
        Diagram(
          coordinateSystem(preserveAspectRatio=false)));

  end Coil;

  partial model Damper
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";

    parameter Buildings.Templates.Components.Types.Damper typ "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.Location loc
      "Equipment location"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    Modelica.Fluid.Interfaces.FluidPort_a port_a(
      redeclare package Medium = Medium)
      "Entering air"
      annotation (Placement(transformation(extent={{-110,
              -10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(
      redeclare package Medium = Medium)
      "Leaving air"
      annotation (Placement(transformation(extent={{90,-10},
              {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    Bus                                 busCon if typ <> Buildings.Templates.Components.Types.Damper.None
       and typ <> Buildings.Templates.Components.Types.Damper.Barometric and
      typ <> Buildings.Templates.Components.Types.Damper.NoPath
      "Control bus"
      annotation (
        Placement(
          visible=DynamicSelect(true, typ <> Types.Damper.None and
            typ <> Types.Damper.NoPath),
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={0,100}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,100})));

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
        graphics={
          Text(
            visible=DynamicSelect(true, typ <> Types.Damper.None and
              typ <> Types.Damper.NoPath),
            extent={{-151,-116},{149,-156}},
            lineColor={0,0,255},
            textString="%name"),                                Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
       Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
  end Damper;

  partial model Fan
    extends Buildings.Fluid.Interfaces.PartialTwoPort;

    parameter Buildings.Templates.Components.Types.Fan typ "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.Location loc
      "Equipment location"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter AirHandlersFans.Types.ReturnFanControlSensor typCtr=
        AirHandlersFans.Types.ReturnFanControlSensor.None
      "Sensor type used for return fan control" annotation (Evaluate=true,
        Dialog(group="Configuration", enable=loc == Buildings.Templates.Components.Types.Location.Return
             and typ <> Buildings.Templates.Components.Types.Fan.None));

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
      if typ <>Buildings.Templates.Components.Types.Fan.None
                               then (
        if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                  then
          dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
        else 0)
        else 0
      "Mass flow rate"
      annotation (Dialog(group="Nominal condition",
          enable=typ <> Buildings.Templates.Components.Types.Fan.None));
    parameter Modelica.SIunits.PressureDifference dp_nominal=
      if typ <>Buildings.Templates.Components.Types.Fan.None
                               then (
        if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                  then
          dat.getReal(varName=id + ".Mechanical.Supply fan.Total pressure rise.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return fan.Total pressure rise.value")
        else 0)
        else 0
      "Total pressure rise"
      annotation (
        Dialog(group="Nominal condition", enable=typ <> Buildings.Templates.Components.Types.Fan.None));

    replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
      pressure(
        V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
        dp={2*dp_nominal,dp_nominal,0}))
      constrainedby Buildings.Fluid.Movers.Data.Generic
      "Performance data"
      annotation (
        choicesAllMatching=true,
        Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
        Placement(transformation(extent={{-90,-88},{-70,-68}})));

    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    Bus                                 busCon
      if typ <> Buildings.Templates.Components.Types.Fan.None
      "Control bus"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={0,100}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,100})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Fan;

  partial model HeatExchangerDX
    // Air medium needed for type compatibility with DX coil models.
    // And binding of m_flow_nominal with performance data record parameter.
    extends Fluid.Interfaces.PartialTwoPort(
      redeclare package Medium=Buildings.Media.Air);

    parameter Buildings.Templates.Components.Types.HeatExchanger typ
      "Type of heat exchanger"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    // DX coils get nominal air flow rate from data record.
    // Only the air pressure drop needs to be declared.
    parameter Modelica.SIunits.PressureDifference dp_nominal
      "Air pressure drop"
      annotation (Dialog(group="Nominal condition"));

    outer parameter String funStr
      "String used to identify the coil function";
    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    BoundaryConditions.WeatherData.Bus weaBus
      "Weather bus"
      annotation (Placement(
          transformation(extent={{-80,80},{-40,120}}),
          iconTransformation(extent={{-70,90},
              {-50,110}})));
    Bus                                                      busCon "Control bus"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={0,100}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,100})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end HeatExchangerDX;

  partial model HeatExchangerWater
    extends Fluid.Interfaces.PartialFourPortInterface;

    parameter Buildings.Templates.Components.Types.HeatExchanger typ
      "Type of heat exchanger"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Modelica.SIunits.PressureDifference dp1_nominal
      "Liquid pressure drop"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.SIunits.PressureDifference dp2_nominal
      "Air pressure drop"
      annotation (Dialog(group="Nominal condition"));

    outer parameter String funStr
      "String used to identify the coil function";
    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    annotation (Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end HeatExchangerWater;

  partial model Sensor
    extends Buildings.Fluid.Interfaces.PartialTwoPort;

    parameter Boolean have_sen=true
      "Set to true for sensor, false for direct pass through"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.Location loc
      "Equipment location"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Boolean isDifPreSen=false
      "Set to true for differential pressure sensor, false for any other sensor"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
      if have_sen and not isDifPreSen then (
        if loc ==Buildings.Templates.Components.Types.Location.Supply
                                                  then
          dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.OutdoorAir
                                                          then
          dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.MinimumOutdoorAir
                                                                 then
          dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Return
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Relief
                                                      then
          dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
        elseif loc ==Buildings.Templates.Components.Types.Location.Terminal
                                                        then
          dat.getReal(varName=id + ".Mechanical.Discharge air mass flow rate.value")
        else 0)
        else 0
      "Mass flow rate"
      annotation (
       Dialog(group="Nominal condition", enable=have_sen and not isDifPreSen));

    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    Modelica.Fluid.Interfaces.FluidPort_b port_bRef(
      redeclare final package Medium = Medium,
      m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
      h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_sen and isDifPreSen
      "Port at the reference pressure for differential pressure sensor"
      annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));

    Controls.OBC.CDL.Interfaces.RealOutput y if have_sen
      "Connector for measured value"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,120})));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>
The location parameter <code>loc</code> is used to assign nominal parameter values
based on the external system parameter file.
The instance name is used to connect to the propoer I/O control signal.
</p>
</html>"));
  end Sensor;

  expandable connector Bus "Main control bus"
    extends Modelica.Icons.SignalBus;

    BusInput inp "Input points"
      annotation (HideResult=false);
    BusOutput out "Output points"
      annotation (HideResult=false);
    BusSoftware sof "Software points"
      annotation (HideResult=false);
    annotation (
      defaultComponentName="bus");
  end Bus;

  expandable connector BusInput "Control bus with input points"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="busInp");
  end BusInput;

  expandable connector BusOutput "Control bus with output points"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="busOut");
  end BusOutput;

  expandable connector BusSoftware "Control bus with software points"
    extends Modelica.Icons.SignalBus;

    annotation (
      defaultComponentName="busSof");
  end BusSoftware;
end Interfaces;
