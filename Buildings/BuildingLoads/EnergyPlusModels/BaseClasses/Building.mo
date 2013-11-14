within Buildings.BuildingLoads.EnergyPlusModels.BaseClasses;
model Building "Generalized model of a building"

  replaceable BaseClasses.Template_fmu Building_FMU(
    _TSetHea_start=_TSetHea_start,
    _TSetCoo_start=_TSetCoo_start,
    fmi_StartTime=fmi_StartTime,
    fmi_StopTime=fmi_StopTime,
    fmi_CommunicationStepSize=fmi_CommunicationStepSize,
    fmi_fmuLocation=fmi_fmuLocation)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Discrete.Sampler sampler(samplePeriod=900)
    annotation (Placement(transformation(extent={{-54,30},{-34,50}})));
  Modelica.Blocks.Discrete.Sampler sampler1(
                                           samplePeriod=900)
    annotation (Placement(transformation(extent={{-54,-52},{-34,-32}})));
  Modelica.Blocks.Interfaces.RealOutput PTotLights(final quantity="Power", final unit="W")
    "Total electric lighting power"
    annotation (Placement(transformation(extent={{80,60},{100,80}}),
        iconTransformation(extent={{80,60},{100,80}})));
  Modelica.Blocks.Sources.RealExpression LightElecPow(y=P_Lights)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.SIunits.Power P_Lights, P_Equip;
  Modelica.Blocks.Interfaces.RealInput Tsp_Heat "Continuous input signal"
    annotation (Placement(transformation(extent={{-100,20},{-60,60}}),
        iconTransformation(extent={{-100,20},{-60,60}})));
  Modelica.Blocks.Interfaces.RealInput Tsp_Cool "Continuous input signal"
    annotation (Placement(transformation(extent={{-100,-62},{-60,-22}}),
        iconTransformation(extent={{-100,-62},{-60,-22}})));
  parameter Modelica.SIunits.Time fmi_StartTime=0 "Fmi start time"
    annotation (Dialog(group="Step time"));
  parameter Modelica.SIunits.Time fmi_StopTime=172800 "Fmi stop time"
    annotation (Dialog(group="Step time"));
  parameter Modelica.SIunits.Time fmi_CommunicationStepSize=900
    "Fmi communication step size (STEP USED BY E+)"
    annotation (Dialog(group="Step time"));
  parameter Modelica.SIunits.Temp_C _TSetHea_start=22
    "Initial value for the heating Set Point "
    annotation (Dialog(group="Initialization"));
  parameter Modelica.SIunits.Temp_C _TSetCoo_start=26
    "Initial value for the cooling Set Point "
    annotation (Dialog(group="Initialization"));
  Modelica.Blocks.Sources.RealExpression LightElecPow1(y=P_Equip)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Interfaces.RealOutput PTotEquip(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,40},{100,60}}), iconTransformation(extent={{80,40},
            {100,60}})));
  Modelica.Blocks.Interfaces.RealOutput E_VavTotHeat(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,0},{100,20}}),  iconTransformation(extent={{80,0},{
            100,20}})));
  Modelica.Blocks.Interfaces.RealOutput E_VavTotCool(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,-20},{100,0}}),iconTransformation(extent={{80,-20},
            {100,0}})));
  Modelica.Blocks.Interfaces.RealOutput E_VavGasHeat(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,-40},{100,-20}}),
                                                   iconTransformation(extent={{80,-40},
            {100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput E_VavDxHeat(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,-60},{100,-40}}), iconTransformation(extent={{80,-60},
            {100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput E_VavDxCool(final quantity="Power",
      final unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,-80},{100,-60}}), iconTransformation(extent={{80,-80},
            {100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput P_Fan(final quantity="Power", final
      unit="W") "Total electric lighting power" annotation (Placement(
        transformation(extent={{80,20},{100,40}}), iconTransformation(extent={{80,20},
            {100,40}})));
  parameter String fmi_fmuLocation="*PATH-TO-BUILDINGS*/Resources/Library/FMU/*Name*/"
    annotation (Dialog(group="Instantiation"));
equation
  E_VavTotHeat = Building_FMU.E_0Vav_0tot_0Hea/fmi_CommunicationStepSize;
  E_VavTotCool = Building_FMU.E_0Vav_0tot_0Coo/fmi_CommunicationStepSize;
  E_VavGasHeat = Building_FMU.E_0Vav_0gas_0Hea/fmi_CommunicationStepSize;
  E_VavDxHeat = Building_FMU.E_0Vav_0DX_0Hea/fmi_CommunicationStepSize;
  E_VavDxCool = Building_FMU.E_0Vav_0DX_0Coo/fmi_CommunicationStepSize;
  P_Fan = Building_FMU.P_0Fan;

  P_Lights = Building_FMU.P_0Lights_010 + Building_FMU.P_0Lights_01
           + Building_FMU.P_0Lights_02 + Building_FMU.P_0Lights_03
           + Building_FMU.P_0Lights_04 + Building_FMU.P_0Lights_05
           + Building_FMU.P_0Lights_06 + Building_FMU.P_0Lights_07
           + Building_FMU.P_0Lights_08 + Building_FMU.P_0Lights_09
           + Building_FMU.P_0Lights_011 + Building_FMU.P_0Lights_012
           + Building_FMU.P_0Lights_013 + Building_FMU.P_0Lights_014
           + Building_FMU.P_0Lights_015;

  P_Equip  = Building_FMU.P_0Equip_010 + Building_FMU.P_0Equip_01
           + Building_FMU.P_0Equip_02 + Building_FMU.P_0Equip_03
           + Building_FMU.P_0Equip_04 + Building_FMU.P_0Equip_05
           + Building_FMU.P_0Equip_06 + Building_FMU.P_0Equip_07
           + Building_FMU.P_0Equip_08 + Building_FMU.P_0Equip_09
           + Building_FMU.P_0Equip_011 + Building_FMU.P_0Equip_012
           + Building_FMU.P_0Equip_013 + Building_FMU.P_0Equip_014
           + Building_FMU.P_0Equip_015;

  connect(sampler.y,Building_FMU. TSetHea) annotation (Line(
      points={{-33,40},{-26,40},{-26,3.4},{-10.4,3.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler1.y,Building_FMU. TSetCoo) annotation (Line(
      points={{-33,-42},{-26,-42},{-26,-3.3},{-10.4,-3.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler.u, Tsp_Heat) annotation (Line(
      points={{-56,40},{-80,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler1.u, Tsp_Cool) annotation (Line(
      points={{-56,-42},{-80,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LightElecPow.y, PTotLights) annotation (Line(
      points={{61,70},{90,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LightElecPow1.y, PTotEquip) annotation (Line(
      points={{61,50},{90,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                               Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={213,255,170}), Text(
          extent={{-120,140},{120,100}},
          lineColor={0,0,255},
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Building;
