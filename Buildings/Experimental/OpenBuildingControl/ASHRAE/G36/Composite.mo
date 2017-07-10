within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
package Composite "Sequences as defined in G36"

  model EconomizerMultiZone "Multiple zone VAV AHU economizer control sequence"

    parameter Boolean use_enthalpy = true
      "Set to true if enthalpy measurement is used in addition to temperature measurement";
    parameter Real kPDamLim=1 "Gain of damper limit controller";
    parameter Real kPMod=1 "Gain of modulation controller";
    parameter Modelica.SIunits.Time TiDamLim=0.9 "Time constant of damper limit controller integrator block";
    parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block";

    CDL.Interfaces.RealInput TCooSet(unit="K", quantity = "ThermodynamicTemperature")
      "Supply air temperature cooling setpoint" annotation (Placement(transformation(
      extent={{-140,30},{-120,50}}), iconTransformation(extent={{-120,10},{-100,30}})));
    CDL.Interfaces.RealInput TSup(unit="K", quantity = "ThermodynamicTemperature")
      "Measured supply air temperature" annotation (Placement(transformation(
      extent={{-140,50},{-120,70}}), iconTransformation(extent={{-120,30},{-100,50}})));
    CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature")
      "Outdoor air (OA) temperature" annotation (Placement(transformation(extent={{-140,130},{-120,150}}),
      iconTransformation(extent={{-120,110},{-100,130}})));
    CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
      "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
      annotation (Placement(transformation(extent={{-140,110},{-120,130}}),
          iconTransformation(extent={{-120,90},{-100,110}})));
    CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
      "Outdoor air enthalpy" annotation (Placement(transformation(extent={{-140,90},{-120,110}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
    CDL.Interfaces.RealInput hOutCut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
      "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
      annotation (Placement(transformation(extent={{-140,70},{-120,90}}),
          iconTransformation(extent={{-120,50},{-100,70}})));
    CDL.Interfaces.RealInput VOut_flow(unit="m3/s", quantity="VolumeFlowRate")
      "Measured outdoor volumetirc airflow rate [fixme: which quantity attribute should we use? add for all V]"
      annotation (Placement(transformation(extent={{-140,10},{-120,30}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    CDL.Interfaces.RealInput VOutMinSet_flow(unit="m3/s", quantity="VolumeFlowRate")
      "Minimum outdoor volumetric airflow rate setpoint"
      annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
          iconTransformation(extent={{-120,-30},{-100,-10}})));
    CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status"
      annotation (Placement(transformation(extent={{-140,-130},{-120,-110}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
    CDL.Interfaces.IntegerInput uOperationMode "AHU operation mode status signal"
      annotation (Placement(transformation(extent={{-140,-90},{-120,-70}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
    CDL.Interfaces.IntegerInput uZoneState "Zone state input"
      annotation (Placement(transformation(extent={{-140,-110},{-120,-90}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
    CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
      annotation (Placement(transformation(extent={{-140,-50},{-120,-30}}),
          iconTransformation(extent={{-120,-50},{-100,-30}})));

    CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
      annotation (Placement(transformation(extent={{120,30},{140,50}}),
      iconTransformation(extent={{100,10}, {120,30}})));
    CDL.Interfaces.RealOutput yOutDamPos "Outdoor air damper position"
      annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
      iconTransformation(extent={{100,-30}, {120,-10}})));

    Atomic.EconEnableDisableMultiZone econEnableDisableMultiZone(
      final delEntHis=delEntHis,
      final delTemHis=delTemHis,
      use_enthalpy=use_enthalpy) "Multizone VAV AHU economizer enable/disable sequence"
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    Atomic.EconDamperPositionLimitsMultiZone ecoDamLim(
      retDamPhyPosMax=0.9,
      retDamPhyPosMin=0,
      outDamPhyPosMax=0.9,
      outDamPhyPosMin=0,
      kPDamLim=kPDamLim,
      TiDamLim=TiDamLim) "Multizone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Atomic.EconModulationMultiZone ecoMod(kPMod=kPMod, TiMod=TiMod)
      "Multizone VAV AHU economizer damper modulation sequence"
      annotation (Placement(transformation(extent={{60,0},{80,20}})));

  protected
    parameter Real delEntHis(unit="J/kg", quantity="SpecificEnergy")=1000
      "Delta between the enthalpy hysteresis high and low limits"
      annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy));
    parameter Modelica.SIunits.Temperature delTemHis=1
      "Delta between the temperature hysteresis high and low limits";

  equation
    connect(uSupFan, econEnableDisableMultiZone.uSupFan)
      annotation (Line(points={{-130,-40},{-80,-40},{-80,-32},{-1,-32}},color={255,0,255}));
    connect(uZoneState, econEnableDisableMultiZone.uZoneState)
      annotation (Line(points={{-130,-100},{-70,-100},{-70,-30},{-1,-30}},color={255,127,0}));
    connect(uFreProSta, econEnableDisableMultiZone.uFreProSta)
      annotation (Line(points={{-130,-120},{-60,-120},{-60,-28},{-1,-28}},color={255,127,0}));
    connect(hOutCut, econEnableDisableMultiZone.hOutCut)
      annotation (Line(points={{-130,80},{-46,80},{-46,-26},{-1,-26}},color={0,0,127}));
    connect(hOut, econEnableDisableMultiZone.hOut)
      annotation (Line(points={{-130,100},{-44,100},{-44,-24},{-1,-24}},color={0,0,127}));
    connect(TOutCut, econEnableDisableMultiZone.TOutCut)
      annotation (Line(points={{-130,120},{-42,120},{-42,-22},{-1,-22}},color={0,0,127}));
    connect(TOut, econEnableDisableMultiZone.TOut)
      annotation (Line(points={{-130,140},{-40,140},{-40,-20},{-1,-20}},color={0,0,127}));
    connect(VOutMinSet_flow, ecoDamLim.VOutMinSet_flow)
      annotation (Line(points={{-130,0},{-110,0},{-110,14},{-110,15},{-81,15}},color={0,0,127}));
    connect(VOut_flow, ecoDamLim.VOut_flow)
      annotation (Line(points={{-130,20},{-110,20},{-110,18},{-81,18}},color={0,0,127}));
    connect(uSupFan, ecoDamLim.uSupFan)
      annotation (Line(points={{-130,-40},{-104,-40},{-104,10},{-81,10}},color={255,0,255}));
    connect(uOperationMode, ecoDamLim.uOperationMode)
      annotation (Line(points={{-130,-80},{-102,-80},{-102,4},{-102,5},{-81,5}}, color={255,127,0}));
    connect(uFreProSta, ecoDamLim.uFreProSta)
      annotation (Line(points={{-130,-120},{-100,-120},{-100,2},{-81,2}},color={255,127,0}));
    connect(ecoDamLim.yOutDamPosMax, econEnableDisableMultiZone.uOutDamPosMax)
      annotation (Line(points={{-59,17},{-24,17},{-24,16},{-24,-34},{-1,-34}},
      color={0,0,127}));
    connect(ecoDamLim.yOutDamPosMin, econEnableDisableMultiZone.uOutDamPosMin)
      annotation (Line(points={{-59,15},{-26,15},{-26,12},{-26,-36},{-1,-36}},
      color={0,0,127}));
    connect(ecoDamLim.yRetDamPosMin, econEnableDisableMultiZone.uRetDamPosMin)
      annotation (Line(points={{-59,10},{-28,10},{-28,8},{-28,-42},{-1,-42}},
                                                                           color={0,0,127}));
    connect(ecoDamLim.yRetDamPhyPosMax, econEnableDisableMultiZone.uRetDamPhyPosMax)
      annotation (Line(points={{-59,6},{-32,6},{-32,2},{-32,-38},{-1,-38}},color={0,0,127}));
    connect(ecoDamLim.yRetDamPosMax, econEnableDisableMultiZone.uRetDamPosMax)
      annotation (Line(points={{-59,8},{-30,8},{-30,-40},{-1,-40}},color={0,0,127}));
    connect(ecoMod.yRetDamPos, yRetDamPos)
      annotation (Line(points={{81,12},{100,12},{100,40},{130,40}},color={0,0,127}));
    connect(ecoMod.yOutDamPos, yOutDamPos)
      annotation (Line(points={{81,8},{100,8},{100,-40},{130,-40}},color={0,0,127}));
    connect(econEnableDisableMultiZone.yOutDamPosMax, ecoMod.uOutDamPosMax)
      annotation (Line(points={{22,-25.2},{50,-25.2},{50,-10},{50,11},{59,11}},
      color={0,0,127}));
    connect(econEnableDisableMultiZone.yRetDamPosMax, ecoMod.uRetDamPosMax)
      annotation (Line(points={{22,-32},{52,-32},{52,4},{59,4}},color={0,0,127}));
    connect(ecoDamLim.yOutDamPosMin, ecoMod.uOutDamPosMin)
      annotation (Line(points={{-59,15},{-20,15},{20,15},{20,12},{20,8},{59,8}},
        color={0,0,127}));
    connect(TCooSet, ecoMod.TCooSet) annotation (Line(points={{-130,40},{52,40},{52,19},{59,19}},
        color={0,0,127}));
    connect(TSup, ecoMod.TSup) annotation (Line(points={{-130,60},{50,60},{50,16},{59,16}},color={0,0,127}));
    connect(yOutDamPos, yOutDamPos) annotation (Line(points={{130,-40},{130,-40}}, color={0,0,127}));
    connect(yRetDamPos, yRetDamPos) annotation (Line(points={{130,40},{130,40}}, color={0,0,127}));
    connect(econEnableDisableMultiZone.yRetDamPosMin, ecoMod.uRetDamPosMin)
      annotation (Line(points={{22,-38},{54,-38},{54,0},{54,1},{59,1}}, color={0,0,127}));
    annotation (defaultComponentName = "multiZoneEconomizer",
          Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-66,-36},{-42,-36},{-4,40},{34,40}}, color={28,108,200},
            thickness=0.5),
          Line(
            points={{-64,40},{-38,40},{2,-40},{66,-40}},
            color={28,108,200},
            pattern=LinePattern.Dash,
            thickness=0.5),
          Line(
            points={{34,40},{34,-36},{34,-36},{66,-36}},
            color={28,108,200},
            thickness=0.5)}),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
    Documentation(info="<html>
  <p>
  This is multiple zone VAV AHU economizer control sequence. It calculates
  outdoor and return air damper positions based on ASHRAE
  Guidline 36, sections: PART5 N.2.c, N.5, N.6.c, N.7, A.17, N.12.
  The sequence comprises the following atomic sequences:
  <code>EconDamperPositionLimitsMultiZone</code>,
  <code>EconEnableDisableMultiZone</code>, and
  <code>EconModulationMultiZone</code>.
  </p>
  <p>
  The structure of the economizer control sequence: [fixme: how do I remove the grey area from the image?]
  </p>
  <p align=\"center\">
  <img alt=\"Image of the multizone AHU modulation sequence control diagram\"
  src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/EconCompositeSequenceMultiZone.png\"/>
  </p>
  </html>",   revisions="<html>
  <ul>
  <li>
  June 28, 2017, by Milica Grahovac:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
  end EconomizerMultiZone;

  package Validation "Package with validation models"
    extends Modelica.Icons.ExamplesPackage;

    model EconomizerMultiZone_Disable
      "Validation model for disabling the multizone VAV AHU economizer modulation and damper position limit control loops"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Temperature TOutCutoff=297
        "Outdoor temperature high limit cutoff";
      parameter Real hOutCutoff(unit="J/kg", quantity="SpecificEnergy")=65100
        "Outdoor air enthalpy high limit cutoff";
      parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=0.71
        "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
      parameter Real TSupSet(unit="K", quantity="TermodynamicTemperature")=291 "Supply air temperature setpoint";

      parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
        "Indicates that the freeze protection is disabled";
      parameter Integer freProDisabledNum = Integer(freProDisabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.FreezeProtectionStage freProEnabled = Types.FreezeProtectionStage.stage2
        "Indicates that the freeze protection is enabled";
      parameter Integer freProEnabledNum = Integer(freProEnabled)-1
        "Numerical value for freeze protection stage 2";
      parameter Types.OperationMode occupied = Types.OperationMode.occupied
        "AHU operation mode is \"Occupied\"";
      parameter Integer occupiedNum = Integer(occupied)
        "Numerical value for \"Occupied\" AHU operation mode";
      parameter Types.ZoneState heating = Types.ZoneState.heating
        "Zone state is heating";
      parameter Integer heatingNum = Integer(heating)
        "Numerical value for heating zone state";

      EconomizerMultiZone economizer(use_enthalpy=true) "Multizone VAV AHU economizer "
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
      CDL.Logical.Constant fanStatus(k=true) "Fan is on"
        annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
      CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status is 0"
        annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
      CDL.Integers.Constant ZoneState(k=heatingNum) "Zone State is heating"
        annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
      CDL.Integers.Constant OperationMode(k=occupiedNum) "AHU operation mode is \"Occupied\""
        annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
      CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 40000)
        "Outdoor air enthalpy is below the cufoff"
        annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
      CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
        annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
      CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 30)
        "Outdoor air temperature is below the cutoff"
        annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
      CDL.Continuous.Constant TOutCut1(k=TOutCutoff)
        annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
      CDL.Continuous.Constant VOutMinSet_flow(k=VOutSet_flow)
        "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
      Modelica.Blocks.Sources.Ramp VOut_flow(
        duration=1800,
        height=0.2,
        offset=VOutSet_flow - 0.1)
        "Measured outdoor air volumetric airflow"
        annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
      Modelica.Blocks.Sources.Ramp TSup(
        height=4,
        offset=TSupSet - 2,
        duration=1800)
        "Supply air temperature"
        annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
      CDL.Continuous.Constant TSupSetSig(k=TSupSet) "Cooling supply air temperature setpoint"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      EconomizerMultiZone economizer1 "Multizone VAV AHU economizer"
        annotation (Placement(transformation(extent={{100,-20},{120,0}})));
      CDL.Integers.Constant freProSta2(k=freProEnabledNum) "Freeze protection stage is 2"
        annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

    equation
      connect(fanStatus.y, economizer.uSupFan) annotation (Line(points={{-19,-10},{-10,-10},{-10,6},{19,6}},
        color={255,0,255}));
      connect(freProSta.y, economizer.uFreProSta)
        annotation (Line(points={{-59,-120},{0,-120},{0,0},{19,0}},color={255,127,0}));
      connect(OperationMode.y, economizer.uOperationMode)
        annotation (Line(points={{-59,-90},{-52,-90},{-52,-30},{-4,-30},{-4,4},{19,4}},color={255,127,0}));
      connect(ZoneState.y, economizer.uZoneState)
        annotation (Line(points={{-59,-60},{-50,-60},{-50,-32},{-2,-32},{-2,2},{19,2}}, color={255,127,0}));
      connect(TOutBelowCutoff.y, economizer.TOut)
        annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},color={0,0,127}));
      connect(TOutCut1.y, economizer.TOutCut)
        annotation (Line(points={{-99,70},{-90,70},{-8,70},{-8,20},{19,20}},color={0,0,127}));
      connect(hOutBelowCutoff.y, economizer.hOut)
        annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},color={0,0,127}));
      connect(hOutCut.y, economizer.hOutCut)
        annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},color={0,0,127}));
      connect(VOut_flow.y, economizer.VOut_flow)
        annotation (Line(points={{-19,90},{-8,90},{-8,10},{19,10}},color={0,0,127}));
      connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow)
        annotation (Line(points={{-19,50},{-10,50},{-10,8},{19,8}},color={0,0,127}));
      connect(TSup.y, economizer.TSup)
        annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}},color={0,0,127}));
      connect(TSupSetSig.y, economizer.TCooSet)
        annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},color={0,0,127}));
      connect(TOutCut1.y, economizer1.TOutCut)
        annotation (Line(points={{-99,70},{74,70},{74,0},{99,0}}, color={0,0,127}));
      connect(TOutBelowCutoff.y, economizer1.TOut)
        annotation (Line(points={{-99,110},{80,110},{80,2},{99,2}}, color={0,0,127}));
      connect(hOutCut.y, economizer1.hOutCut)
        annotation (Line(points={{-99,-20},{-90,-20},{-90,-28},{76,-28},{76,-4},{99,-4}},color={0,0,127}));
      connect(hOutBelowCutoff.y, economizer1.hOut)
        annotation (Line(points={{-99,20},{-88,20},{-88,-26},{74,-26},{74,-2},{99,-2}},color={0,0,127}));
      connect(TSup.y, economizer1.TSup)
        annotation (Line(points={{-59,90},{-50,90},{-50,118},{82,118},{82,-6},{99,-6}}, color={0,0,127}));
      connect(TSupSetSig.y, economizer1.TCooSet)
        annotation (Line(points={{-59,50},{-52,50},{-52,68},{72,68},{72,-8},{99,-8}}, color={0,0,127}));
      connect(VOut_flow.y, economizer1.VOut_flow)
        annotation (Line(points={{-19,90},{78,90},{78,-10},{99,-10}}, color={0,0,127}));
      connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow)
        annotation (Line(points={{-19,50},{70,50},{70,-12},{99,-12}}, color={0,0,127}));
      connect(fanStatus.y, economizer1.uSupFan)
        annotation (Line(points={{-19,-10},{20,-10},{20,-14},{99,-14}}, color={255,0,255}));
      connect(ZoneState.y, economizer1.uZoneState)
        annotation (Line(points={{-59,-60},{20,-60},{20,-18},{99,-18}}, color={255,127,0}));
      connect(OperationMode.y, economizer1.uOperationMode)
        annotation (Line(points={{-59,-90},{18,-90},{18,-16},{99,-16}}, color={255,127,0}));
      connect(freProSta2.y, economizer1.uFreProSta)
        annotation (Line(points={{81,-120},{90,-120},{90,-20},{99,-20}}, color={255,127,0}));
      annotation (
        experiment(StopTime=1800.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/Validation/EconomizerMultiZone_Disable.mos"
        "Simulate and plot"),
      Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}}),
            graphics={Text(
              extent={{52,106},{86,84}},
              lineColor={28,108,200}),
            Text(
              extent={{2,156},{86,128}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=9,
              textString="Disable modulation
(uZoneState is Heating),
enable minimal
outdoor air control"),
            Text(
              extent={{82,152},{166,124}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=9,
              textString="Disable modulation
(uZoneState is Heating)
disable minimal
outdoor air control
(uFreProSta is Stage2)")}),
        Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone\">
    Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone</a>
    for control signals which disable modulation control loop only (<code>economizer</code> block)
    and both minimum outdoor airflow and modulation control loops (<code>economizer1</code> block).
    </p>
    </html>",     revisions="<html>
    <ul>
    <li>
    June 12, 2017, by Milica Grahovac:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
    end EconomizerMultiZone_Disable;

    model EconomizerMultiZone_Mod_DamLim
      "Validation model for multizone VAV AHU economizer operation: damper modulation and minimum ooutdoor air requirement damper position limits"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Temperature TOutCutoff=297
        "Outdoor temperature high limit cutoff";
      parameter Real hOutCutoff(unit="J/kg", quantity="SpecificEnergy")=65100
        "Outdoor air enthalpy high limit cutoff";
      parameter Modelica.SIunits.Temperature TCooSet=291
        "Supply air temperature cooling setpoint";
      parameter Modelica.SIunits.Temperature TSup=290
        "Measured supply air temperature";

      parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
        "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
      parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.705
        "Minimal measured volumetric airflow";
      parameter Modelica.SIunits.VolumeFlowRate VOutIncrease_flow=0.03
        "Maximum volumetric airflow increase during the example simulation";

      parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
        "Indicates that the freeze protection is disabled";
      parameter Integer freProDisabledNum = Integer(freProDisabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.OperationMode occupied = Types.OperationMode.occupied
        "AHU operation mode is \"Occupied\"";
      parameter Integer occupiedNum = Integer(occupied)
        "Numerical value for \"Occupied\" AHU operation mode";
      parameter Types.ZoneState deadband = Types.ZoneState.deadband
        "Zone state is deadband";
      parameter Integer deadbandNum = Integer(deadband)
        "Numerical value for deadband zone state";

      EconomizerMultiZone economizer(use_enthalpy=true) "Multizone VAV AHU economizer"
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
      CDL.Logical.Constant fanStatus(k=true) "Fan is on"
        annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
      CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status is 0"
        annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
      CDL.Integers.Constant ZoneState(k=deadbandNum) "Zone State is deadband"
        annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
      CDL.Integers.Constant operationMode(k=occupiedNum) "AHU operation mode is \"Occupied\""
        annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
      CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 10000)
        "Outdoor air enthalpy is slightly below the cufoff"
        annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
      CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
        annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
      CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 5)
        "Outdoor air temperature is slightly below the cutoff"
        annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
      CDL.Continuous.Constant TOutCut1(k=TOutCutoff)
        annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
      CDL.Continuous.Constant VOutMinSet_flow(k=minVOutSet_flow)
        "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
      Modelica.Blocks.Sources.Ramp VOut_flow(
        duration=1800,
        offset=minVOut_flow,
        height=VOutIncrease_flow)
        "Measured outdoor air volumetric airflow"
        annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
      CDL.Continuous.Constant TSupSetSig(k=TCooSet) "Cooling supply air temperature setpoint"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      CDL.Continuous.Constant TSupSig(k=TSup) "Measured supply air temperature"
        annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
      EconomizerMultiZone economizer1(use_enthalpy=false) "Multizone VAV AHU economizer "
        annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
      Modelica.Blocks.Sources.Ramp TSupSig1(
        duration=900,
        height=2,
        offset=TCooSet - 1) "Measured supply air temperature"
        annotation (Placement(transformation(extent={{40,80},{60,100}})));
    equation
      connect(fanStatus.y, economizer.uSupFan)
        annotation (Line(points={{-59,-80},{-14,-80},{-14,6},{19,6}}, color={255,0,255}));
      connect(freProSta.y, economizer.uFreProSta)
        annotation (Line(points={{-59,-120},{0,-120},{0,0},{19,0}},color={255,127,0}));
      connect(operationMode.y, economizer.uOperationMode)
        annotation (Line(points={{-99,-100},{-50,-100},{-50,-30},{-4,-30},{-4,4},{19,4}},color={255,127,0}));
      connect(ZoneState.y, economizer.uZoneState)
        annotation (Line(points={{-99,-60},{-48,-60},{-48,-32},{-2,-32},{-2,2},{19,2}}, color={255,127,0}));
      connect(TOutBelowCutoff.y, economizer.TOut)
        annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},color={0,0,127}));
      connect(TOutCut1.y, economizer.TOutCut)
        annotation (Line(points={{-99,70},{-10,70},{-10,20},{19,20}}, color={0,0,127}));
      connect(hOutBelowCutoff.y, economizer.hOut)
        annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},color={0,0,127}));
      connect(hOutCut.y, economizer.hOutCut)
        annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},color={0,0,127}));
      connect(VOut_flow.y, economizer.VOut_flow)
        annotation (Line(points={{-19,90},{-8,90},{-8,10},{19,10}},color={0,0,127}));
      connect(VOutMinSet_flow.y, economizer.VOutMinSet_flow)
        annotation (Line(points={{-19,50},{-12,50},{-12,8},{19,8}},color={0,0,127}));
      connect(TSupSetSig.y, economizer.TCooSet)
        annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},color={0,0,127}));
      connect(TSupSig.y, economizer.TSup)
        annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}}, color={0,0,127}));
      connect(TOutBelowCutoff.y, economizer1.TOut)
        annotation (Line(points={{-99,110},{90,110},{90,-18},{99,-18}}, color={0,0,127}));
      connect(TOutCut1.y, economizer1.TOutCut)
        annotation (Line(points={{-99,70},{88,70},{88,-20},{99,-20}}, color={0,0,127}));
      connect(TSupSig1.y, economizer1.TSup) annotation (Line(points={{61,90},{80,90},{80,-26},{99,-26}}, color={0,0,127}));
      connect(TSupSetSig.y, economizer1.TCooSet)
        annotation (Line(points={{-59,50},{-54,50},{-54,-20},{20,-20},{20,-28},{99,-28}}, color={0,0,127}));
      connect(VOut_flow.y, economizer1.VOut_flow)
        annotation (Line(points={{-19,90},{-10,90},{-10,-22},{18,-22},{18,-30},{99,-30}}, color={0,0,127}));
      connect(VOutMinSet_flow.y, economizer1.VOutMinSet_flow)
        annotation (Line(points={{-19,50},{-12,50},{-12,-24},{16,-24},{16,-32},{99,-32}}, color={0,0,127}));
      connect(fanStatus.y, economizer1.uSupFan)
        annotation (Line(points={{-59,-80},{20,-80},{20,-34},{99,-34}}, color={255,0,255}));
      connect(operationMode.y, economizer1.uOperationMode)
        annotation (Line(points={{-99,-100},{22,-100},{22,-36},{99,-36}}, color={255,127,0}));
      connect(freProSta.y, economizer1.uFreProSta)
        annotation (Line(points={{-59,-120},{26,-120},{26,-40},{99,-40}}, color={255,127,0}));
      connect(ZoneState.y, economizer1.uZoneState)
        annotation (Line(points={{-99,-60},{24,-60},{24,-38},{99,-38}}, color={255,127,0}));
      connect(hOutBelowCutoff.y, economizer1.hOut)
        annotation (Line(points={{-99,20},{0,20},{0,-22},{99,-22}}, color={0,0,127}));
      connect(hOutCut.y, economizer1.hOutCut)
        annotation (Line(points={{-99,-20},{0,-20},{0,-24},{99,-24}}, color={0,0,127}));
      annotation (
        experiment(StopTime=900.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Composite/Validation/EconomizerMultiZone_Mod_DamLim.mos"
        "Simulate and plot"),
      Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}}),
            graphics={
            Rectangle(
              extent={{-136,-44},{-44,-156}},
              lineColor={0,0,0},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
                      Text(
              extent={{52,106},{86,84}},
              lineColor={28,108,200}),
            Text(
              extent={{-128,-130},{-44,-158}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=9,
              textString="Enable both damper limit
and modulation control loops"),
            Text(
              extent={{100,4},{136,-16}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=8,
              textString="Validate damper modulation
(example without
enthalpy measurement)"),
            Text(
              extent={{20,46},{56,26}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=8,
              textString="Economizer fully enabled -
validate damper position limits")}),
        Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone\">
    Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite.EconomizerMultiZone</a> control loops:
    minimum outdoor air damper position limits control loop (<code>economizer</code> block) and modulation
    control loop (<code>economizer1</code> block) for <code>VOut_flow</code> and <code>TSup</code> control signals. Both control
    loops are enabled during the validation test.
    </p>
    </html>",     revisions="<html>
    <ul>
    <li>
    June 12, 2017, by Milica Grahovac:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
    end EconomizerMultiZone_Mod_DamLim;
  annotation (Documentation(revisions="<html>
</html>",   info="<html>
<p>
This package contains models that validate the control sequences.
The examples plot various outputs, which have been verified against
analytical solutions. These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
  end Validation;
  annotation (Icon(graphics={
        Rectangle(
        extent={{-70,60},{-30,20}},
        lineColor={0,0,127},
        lineThickness=0.5),
        Rectangle(
        extent={{-70,-20},{-30,-60}},
        lineColor={0,0,127},
        lineThickness=0.5),
        Rectangle(
        extent={{30,20},{70,-20}},
        lineColor={0,0,127},
        lineThickness=0.5),
        Line(
        points={{-30,40},{0,40},{0,10},{30,10}},
        color={0,0,127},
        thickness=0.5),
        Line(
        points={{-30,-40},{0,-40},{0,-10},{30,-10}},
        color={0,0,127},
        thickness=0.5)}),
Documentation(info="<html>
<p>
This package contains composite control sequences from
ASHRAE Guideline 36. Composite sequences are customizable
by editing their building blocks, atomic sequences.
</p>
</html>"));
end Composite;
