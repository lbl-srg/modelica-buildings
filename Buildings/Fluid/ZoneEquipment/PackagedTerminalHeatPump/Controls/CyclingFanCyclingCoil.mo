within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls;
model CyclingFanCyclingCoil "Controller for PTHPwith cycle fan and cycle coil"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp,
    final has_fanOpeMod=true);

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.TemperatureDifference dTHys
    "Temperature difference used for enabling cooling and heating mode";

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conHea(dTHys=dTHys,
  conMod=true, tCoiEna=tFanEna)
    annotation (Placement(transformation(extent={{-12,30},{8,50}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc(
                         tFanEnaDel=tFanEnaDel, tFanEna=tFanEna)
    annotation (Placement(transformation(extent={{72,-132},{100,-104}})));
  Modelica.Blocks.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") "Measured supply temperature"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-220,-162},{-180,-122}})));
  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conCoo(dTHys=dTHys,conMod=false, tCoiEna=tFanEna)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan when eithor cooling or heating mode is enabled"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput yHeaMod if not has_varHea and
    has_hea "Heating enable signal" annotation (Placement(transformation(extent=
           {{140,-160},{180,-120}}), iconTransformation(extent={{182,-162},{222,
            -122}})));
equation
  connect(uFan, conHea.uFan) annotation (Line(points={{-160,100},{-60,100},{-60,
          45.7143},{-13.4286,45.7143}}, color={255,0,255}));
  connect(TZon, conHea.TZon) annotation (Line(points={{-160,60},{-50,60},{-50,
          40},{-13.4286,40}}, color={0,0,127}));
  connect(uFan, conFanCyc.uFan) annotation (Line(points={{-160,100},{-60,100},{
          -60,-106},{70,-106}},
                              color={255,0,255}));
  connect(uAva, conFanCyc.uAva) annotation (Line(points={{-160,-60},{-60,-60},{
          -60,-122},{70,-122}},
                              color={255,0,255}));
  connect(fanOpeMod, conFanCyc.fanOpeMod) annotation (Line(points={{-160,-100},
          {-46,-100},{-46,-130},{70,-130}},
                                          color={255,0,255}));
  connect(conFanCyc.yFan, yFan) annotation (Line(points={{102,-122},{132,-122},
          {132,-100},{160,-100}},
                               color={255,0,255}));
  connect(conFanCyc.yFanSpe, yFanSpe) annotation (Line(points={{102,-114},{122,
          -114},{122,-60},{160,-60}},color={0,0,127}));
  connect(TSup, conHea.TSup) annotation (Line(points={{-160,-140},{-40,-140},{
          -40,30},{-13.4286,30}}, color={0,0,127}));
  connect(THeaSet, conHea.TZonSet) annotation (Line(points={{-160,-20},{-30,-20},
          {-30,34.2857},{-13.4286,34.2857}}, color={0,0,127}));
  connect(TZon, conCoo.TZon) annotation (Line(points={{-160,60},{-48,60},{-48,
          -80},{-11.4286,-80}}, color={0,0,127}));
  connect(uFan, conCoo.uFan) annotation (Line(points={{-160,100},{-60,100},{-60,
          -74.2857},{-11.4286,-74.2857}}, color={255,0,255}));
  connect(TCooSet, conCoo.TZonSet) annotation (Line(points={{-160,20},{-22,20},
          {-22,-85.7143},{-11.4286,-85.7143}}, color={0,0,127}));
  connect(TSup, conCoo.TSup) annotation (Line(points={{-160,-140},{-22,-140},{
          -22,-90},{-11.4286,-90}}, color={0,0,127}));
  connect(conCoo.yEna, yCooEna) annotation (Line(points={{11.4286,-80},{100,-80},
          {100,100},{160,100}}, color={255,0,255}));
  connect(conHea.y, yHea) annotation (Line(points={{9.42857,45.7143},{92,
          45.7143},{92,-20},{160,-20}}, color={0,0,127}));
  connect(conCoo.y, yCoo) annotation (Line(points={{11.4286,-74.2857},{80,
          -74.2857},{80,20},{160,20}}, color={0,0,127}));
  connect(conHea.yMod, or2.u1) annotation (Line(points={{9.42857,34.2857},{20,
          34.2857},{20,-50},{28,-50}},
                            color={255,0,255}));
  connect(conCoo.yMod, or2.u2) annotation (Line(points={{11.4286,-85.7143},{20,
          -85.7143},{20,-58},{28,-58}},
                            color={255,0,255}));
  connect(or2.y, conFanCyc.heaCooOpe) annotation (Line(points={{52,-50},{56,-50},
          {56,-114},{70,-114}},
                             color={255,0,255}));
  connect(conHea.yEna, yHeaEna) annotation (Line(points={{9.42857,40},{78,40},{
          78,60},{160,60}}, color={255,0,255}));
  connect(conHea.yMod, yHeaMod) annotation (Line(points={{9.42857,34.2857},{18,
          34.2857},{18,-140},{160,-140}}, color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,220}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,
            120}})),
    Documentation(info="<html>
<p><br>This is a control module for the PTHP system model designed as an analogue to the control logic in EnergyPlus. The components are operated as follows. </p>
<ul>
<li>When <span style=\"font-family: Courier New;\">TZon</span> is below the heating setpoint temperature <span style=\"font-family: Courier New;\">THeaSet</span>, the PTHP enters heating mode operation (<span style=\"font-family: Courier New;\">yHeaMod = True</span>). The constant fan is enabled (<span style=\"font-family: Courier New;\">yFan = True</span>) and DX heating coil is enabled (<span style=\"font-family: Courier New;\">yHeaEna = True</span>). Otherwise, the fan and DX heating coil are disabled. </li>
<li>When <span style=\"font-family: Courier New;\">TZon</span> is below the cooling setpoint temperature <span style=\"font-family: Courier New;\">TCooSet</span>, the PTHP enters cooling mode operation (<span style=\"font-family: Courier New;\">yCooMod = True</span>). The constant fan is enabled (<span style=\"font-family: Courier New;\">yFan = True</span>) and DX cooling coil is enabled (<span style=\"font-family: Courier New;\">yCooEna = True</span>). Otherwise, the fan and DX cooling coil are disabled. </li>
</ul>
<p><span style=\"font-family: Courier New;\">dTHys</span> is the hysteresis temperature difference for enabling/disabling the cooling/heating mode. </p>
</html>
", revisions="<html>
    <ul>
    <li>
    Mar 30, 2023 by Karthik Devaprasad, Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Controls/Validation/CyclingFanCyclingCoil.mos"
        "Simulate and Plot"));
end CyclingFanCyclingCoil;
