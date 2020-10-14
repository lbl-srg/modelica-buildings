within Buildings.Controls.OBC.FDE.DOAS;
block DOAScontroller
    "DOAS controller built from DOAS blocks."

 parameter Boolean vvUnit = true
   "Set true when unit serves variable volume system."
   annotation (Dialog(tab="DOAS", group="General"));

 parameter Real damSet(
   min=0,
   max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point"
   annotation (Dialog(tab="DOAS", group="General"));

  parameter Real cctPIk = 0.0000001
  "Cooling coil CCT PI gain value k."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real cctPITi = 0.000025
  "Cooling coil CCT PI time constant value Ti."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real SAccPIk = 0.0000001
  "Cooling coil SAT PI gain value k."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real SAccPITi = 0.000025
  "Cooling coil SAT PI time constant value Ti."
  annotation (Dialog(tab="Cooling Coil", group="PI Parameters"));

  parameter Real dehumSet(
    final min=0,
    final max=100,
    final displayUnit="rh")=60
   "Dehumidification set point."
    annotation (Dialog(tab="Dehumidification", group="Set Point"));

  parameter Real dehumDelay(
    final unit="s",
    final quantity="Time")=600
    "Minimum delay after RH falls below set point before turning dehum off."
     annotation (Dialog(tab="Dehumidification", group="Timer"));

  parameter Real minRun(
    final unit="s",
    final quantity="Time")=120
    "Minimum supply fan proof delay before allowing dehum mode."
     annotation (Dialog(tab="Dehumidification", group="Timer"));

  parameter Real econCooAdj(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=2
    "Value subtracted from supply air temperature cooling set point."
     annotation (Dialog(tab="Economizer", group="Set Point"));

 parameter Real erwDPadj(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=5
    "Value subtracted from ERW supply air dewpoint."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Set Point"));

 parameter Real recSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=7
    "Energy recovery set point."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Set Point"));

 parameter Real recSetDelay(
    final unit="s",
    final quantity="Time")=300
    "Minimum delay after OAT/RAT delta falls below set point."
    annotation (Dialog(tab="Energy Recovery Wheel", group="Timer"));

 parameter Real kGain(
    final unit="1")=0.00001
    "PID loop gain value."
    annotation (Dialog(tab="Energy Recovery Wheel", group="PI Parameters"));

 parameter Real conTi(
    final unit="s")=0.00025
    "PID time constant of integrator."
    annotation (Dialog(tab="Energy Recovery Wheel", group="PI Parameters"));

 parameter Real SArhcPIk = 0.0000001
  "Heating coil SAT PI gain value k."
  annotation (Dialog(tab="Heating Coil", group="PI Parameters"));

 parameter Real SArhcPITi = 0.000025
  "Heating coil SAT PI time constant value Ti."
  annotation (Dialog(tab="Heating Coil", group="PI Parameters"));

 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=125
    "Minimum down duct static pressure reset value"
      annotation (Dialog(tab="Pressure", group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=500
    "Maximum down duct static pressure reset value"
      annotation (Dialog(tab="Pressure", group="DDSP range"));

  parameter Real cvDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=250
    "Constant volume down duct static pressure set point"
      annotation (Dialog(tab="Pressure", group="CV DDSP"));

 parameter Real bldgSPset(
   final unit="Pa",
   final quantity="PressureDifference")=15
    "Building static pressure set point"
    annotation (Dialog(tab="Pressure", group="Building"));

 parameter Real loPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+20
   "Minimum primary supply air temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real hiPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+24
   "Maximum primary supply air temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real hiZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+25
   "Maximum zone temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real loZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+21
   "Minimum zone temperature reset value"
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real coAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature cooling set point offset."
   annotation (Dialog(tab="Temperature", group="Set Point"));

 parameter Real heAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature heating set point offset."
   annotation (Dialog(tab="Temperature", group="Set Point"));

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-142,56},{-102,96}}),
        iconTransformation(extent={{-140,76},{-100,116}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
    "Most open damper position from all terminal units served."
    annotation (Placement(transformation(extent={{-142,30},{-102,70}}),
        iconTransformation(extent={{-140,52},{-100,92}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanStatus
    "True when supply fan is proven on."
    annotation (Placement(transformation(extent={{-140,4},{-100,44}}),
        iconTransformation(extent={{-140,28},{-100,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput DDSP(
   final unit="Pa",
   final quantity="PressureDifference")
    "Down duct static pressure measurement."
    annotation (Placement(transformation(extent={{-140,-22},{-100,18}}),
        iconTransformation(extent={{-140,4},{-100,44}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput retHum(
      final min=0,
    final max=100,
    final displayUnit="rh")
    "Return air relative humidity sensor."
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput saT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Supply air temperature sensor."
    annotation (Placement(transformation(extent={{-140,-106},{-100,-66}}),
        iconTransformation(extent={{-140,-72},{-100,-32}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ccT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Cooling coil discharge air temperature sensor."
    annotation (Placement(transformation(extent={{-140,-184},{-100,-144}}),
        iconTransformation(extent={{-140,-146},{-100,-106}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput erwHum(
    final min=0,
    final max=100,
    final displayUnit="rh")
    "ERW relative humidity sensor"
    annotation (Placement(transformation(extent={{-140,-210},{-100,-170}}),
        iconTransformation(extent={{-140,-172},{-100,-132}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput erwT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "ERW dry bulb temperature sensor."
    annotation (Placement(transformation(extent={{-140,-236},{-100,-196}}),
        iconTransformation(extent={{-140,-196},{-100,-156}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput oaT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-158},{-100,-118}}),
      iconTransformation(extent={{-140,-122},{-100,-82}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput raT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Return air temperature sensor."
    annotation (Placement(transformation(extent={{-140,-132},{-100,-92}}),
        iconTransformation(extent={{-140,-96},{-100,-56}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput exhFanProof
    "True when exhaust fan is proven on."
    annotation (Placement(transformation(extent={{-140,-262},{-100,-222}}),
        iconTransformation(extent={{-140,-220},{-100,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput bldgSP(
   final unit="Pa",
   final quantity="PressureDifference")
    "Building static pressure"
    annotation (Placement(transformation(extent={{-140,-290},{-100,-250}}),
        iconTransformation(extent={{-140,-244},{-100,-204}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Highest space temperature reported from all terminal units."
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-46},{-100,-6}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput supFanStart
    "Command supply fan to start when true."
    annotation (Placement(transformation(extent={{102,54},{142,94}}),
      iconTransformation(extent={{102,34},{142,74}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput supFanSpeed
    "Supply fan speed command"
    annotation (Placement(transformation(extent={{102,28},{142,68}}),
      iconTransformation(extent={{102,2},{142,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCC
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{102,2},{142,42}}),
      iconTransformation(extent={{102,-30},{142,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRHC
    "Reheat coil valve command."
    annotation (Placement(transformation(extent={{102,-24},{142,16}}),
      iconTransformation(extent={{102,-60},{142,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput bypDam
    "Bypass damper command; true when commanded full open."
    annotation (Placement(transformation(extent={{102,-50},{142,-10}}),
      iconTransformation(extent={{102,-90},{142,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput erwStart
    "Command to start the energy recovery wheel."
    annotation (Placement(transformation(extent={{102,-74},{142,-34}}),
      iconTransformation(extent={{102,-120},{142,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput erwSpeed
    "Energy recovery wheel speed command."
    annotation (Placement(transformation(extent={{102,-100},{142,-60}}),
        iconTransformation(extent={{102,-152},{142,-112}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput exhFanStart
    "Command exhaust fan to start when true."
    annotation (Placement(transformation(extent={{102,-128},{142,-88}}),
      iconTransformation(extent={{102,-184},{142,-144}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput exhFanSpeed
    "Exhaust fan speed command"
    annotation (Placement(transformation(extent={{102,-156},{142,-116}}),
        iconTransformation(extent={{102,-216},{142,-176}})));

  Buildings.Controls.OBC.FDE.DOAS.SupplyFanController SFcon
    "This block manages start, stop, status, and speed of the supply fan."
    annotation (Placement(transformation(extent={{-84,58},{-64,78}})));
  Buildings.Controls.OBC.FDE.DOAS.ExhaustFanController EFcon
    "This block manages start, stop, and speed of the exhaust fan."
    annotation (Placement(transformation(extent={{58,-106},{78,-86}})));
  Buildings.Controls.OBC.FDE.DOAS.EnergyWheel ERWcon
    "This block commands the energy recovery wheel and 
      associated bypass dampers."
    annotation (Placement(transformation(extent={{58,-64},{78,-44}})));
  Buildings.Controls.OBC.FDE.DOAS.CoolingCoil Cooling
    "This block commands the cooling coil."
    annotation (Placement(transformation(extent={{58,18},{78,38}})));
  Buildings.Controls.OBC.FDE.DOAS.HeatingCoil Heating
    "This block commands the heating coil."
    annotation (Placement(transformation(extent={{58,-18},{78,2}})));
  Buildings.Controls.OBC.FDE.DOAS.TSupSet TSupSetpt
    "This block caclulates the DOAS supply air temperature set point."
    annotation (Placement(transformation(extent={{-8,-6},{12,14}})));
  Buildings.Controls.OBC.FDE.DOAS.DehumMode DehumMod
    "This block calculates when dehumidification mode is active."
    annotation (Placement(transformation(extent={{-48,8},{-28,28}})));
  Buildings.Controls.OBC.FDE.DOAS.EconMode EconMod
    "This block calculates when economizer mode is active."
    annotation (Placement(transformation(extent={{26,-42},{46,-22}})));

equation
  connect(SFcon.occ, occ)
    annotation (Line(points={{-86,75},{-96,75},{-96,76},{-122,76}},
      color={255,0,255}));
  connect(SFcon.mostOpenDam, mostOpenDam)
    annotation (Line(points={{-86,71.4},{-98,71.4},{-98,50},{-122,50}},
      color={0,0,127}));
  connect(SFcon.supFanStatus, supFanStatus)
    annotation (Line(points={{-86,64.4},{-96,64.4},{-96,24},{-120,24}},
      color={255,0,255}));
  connect(SFcon.DDSP, DDSP)
    annotation (Line(points={{-86,60.8},{-94,60.8},{-94,-2},{-120,-2}},
      color={0,0,127}));
  connect(SFcon.supFanStart, supFanStart)
    annotation (Line(points={{-62,73.2},{122,73.2},{122,74}},
      color={255,0,255}));
  connect(SFcon.supFanSpeed, supFanSpeed)
    annotation (Line(points={{-62,63.6},{84,63.6},{84,48},{122,48}},
      color={0,0,127}));
  connect(SFcon.supFanProof, DehumMod.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,25.2},{-50.2,25.2}},
      color={255,0,255}));
  connect(SFcon.supFanProof, Cooling.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,36.4},{55.8,36.4}},
      color={255,0,255}));
  connect(DehumMod.dehumMode, Cooling.dehumMode)
    annotation (Line(points={{-25.8,18},{-22,18},{-22,27.4},{55.8,27.4}},
      color={255,0,255}));
  connect(DehumMod.retHum, retHum)
    annotation (Line(points={{-50.2,18},{-92,18},{-92,-60},{-120,-60}},
      color={0,0,127}));
  connect(Cooling.saT, saT)
    annotation (Line(points={{55.8,33.6},{-90,33.6},{-90,-86},{-120,-86}},
      color={0,0,127}));
  connect(Cooling.ccT, ccT)
    annotation (Line(points={{55.8,24.8},{-20,24.8},{-20,-164},{-120,-164}},
      color={0,0,127}));
  connect(Cooling.erwHum, erwHum)
    annotation (Line(points={{55.8,22.2},{-18,22.2},{-18,-190},{-120,-190}},
      color={0,0,127}));
  connect(Cooling.erwT, erwT)
    annotation (Line(points={{55.8,19.6},{-16,19.6},{-16,-216},{-120,-216}},
      color={0,0,127}));
  connect(Cooling.yCC, yCC)
    annotation (Line(points={{80.2,28},{92,28},{92,22},{122,22}},
      color={0,0,127}));
  connect(SFcon.supFanProof, Heating.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,-8},{55.8,-8}},
      color={255,0,255}));
  connect(saT, Heating.saT)
    annotation (Line(points={{-120,-86},{-90,-86},{-90,-13},{55.8,-13}},
      color={0,0,127}));
  connect(Heating.yRHC, yRHC)
    annotation (Line(points={{80.2,-8},{90,-8},{90,-4},{122,-4}},
      color={0,0,127}));
  connect(ERWcon.erwStart, erwStart)
    annotation (Line(points={{80.2,-54},{122,-54}}, color={255,0,255}));
  connect(ERWcon.erwSpeed, erwSpeed)
    annotation (Line(points={{80.2,-60},{92,-60},{92,-80},{122,-80}},
      color={0,0,127}));
  connect(DehumMod.dehumMode, TSupSetpt.dehumMode)
    annotation (Line(points={{-25.8,18},{-22,18},{-22,9},{-10,9}},
      color={255,0,255}));
  connect(TSupSetpt.supCooSP, Cooling.supCooSP)
    annotation (Line(points={{14.2,8},{20,8},{20,30.8},{55.8,30.8}},
      color={0,0,127}));
  connect(TSupSetpt.supHeaSP, Heating.supHeaSP)
    annotation (Line(points={{14.2,0},{22,0},{22,-3.2},{55.8,-3.2}},
      color={0,0,127}));
  connect(SFcon.supFanProof, ERWcon.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,-46.2},{55.8,-46.2}},
      color={255,0,255}));
  connect(ERWcon.bypDam, bypDam)
    annotation (Line(points={{80.2,-48},{92,-48},{92,-30},{122,-30}},
      color={255,0,255}));
  connect(EconMod.ecoMode, ERWcon.ecoMode)
    annotation (Line(points={{48.2,-32},{52,-32},{52,-49.2},{55.8,-49.2}},
      color={255,0,255}));
  connect(SFcon.supFanProof, EconMod.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,-25},{23.8,-25}},
      color={255,0,255}));
  connect(TSupSetpt.supCooSP, EconMod.supCooSP)
    annotation (Line(points={{14.2,8},{20,8},{20,-39},{23.8,-39}},
      color={0,0,127}));
  connect(EconMod.oaT, oaT)
    annotation (Line(points={{23.8,-32},{-22,-32},{-22,-138},{-120,-138}},
      color={0,0,127}));
  connect(oaT, ERWcon.oaT)
    annotation (Line(points={{-120,-138},{-22,-138},{-22,-55.8},{55.8,-55.8}},
       color={0,0,127}));
  connect(erwT, ERWcon.erwT)
    annotation (Line(points={{-120,-216},{-16,-216},{-16,-58.8},{55.8,-58.8}},
      color={0,0,127}));
  connect(ERWcon.raT, raT)
    annotation (Line(points={{55.8,-52.2},{-88,-52.2},{-88,-112},{-120,-112}},
       color={0,0,127}));
  connect(TSupSetpt.supPrimSP, ERWcon.supPrimSP)
    annotation (Line(points={{14.2,4},{18,4},{18,-61.8},{55.8,-61.8}},
      color={0,0,127}));
  connect(EFcon.exhFanStart, exhFanStart)
    annotation (Line(points={{80,-90},{94,-90},{94,-108},{122,-108}},
      color={255,0,255}));
  connect(EFcon.exhFanSpeed, exhFanSpeed)
    annotation (Line(points={{80,-102},{92,-102},{92,-136},{122,-136}},
      color={0,0,127}));
  connect(SFcon.supFanProof, EFcon.supFanProof)
    annotation (Line(points={{-62,68},{-56,68},{-56,-90},{56,-90}},
      color={255,0,255}));
  connect(EFcon.exhFanProof, exhFanProof)
    annotation (Line(points={{56,-96},{-14,-96},{-14,-242},{-120,-242}},
      color={255,0,255}));
  connect(EFcon.bldgSP, bldgSP)
    annotation (Line(points={{56,-102.4},{-12,-102.4},{-12,-270},{-120,-270}},
      color={0,0,127}));
  connect(TSupSetpt.highSpaceT, highSpaceT)
    annotation (Line(points={{-10,-1},{-88,-1},{-88,-30},{-120,-30}},
      color={0,0,127}));
  annotation (defaultComponentName="DOAScon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},
            {100,100}}),                                        graphics={
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
            Rectangle(extent={{-100,100},{100,-240}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,70},{-50,44}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-76,72},{-30,26}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-58,54},{-48,44}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,-168},{94,-194}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-166},{78,-212}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,-184},{60,-194}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{52,-52},{2,-52}},
                                     color={0,0,0}),
        Ellipse(
          extent={{-10,6},{32,-120}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,6},{12,-120}},
          lineColor={170,255,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,6},{18,-120}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-4,-52},{-54,-52}},
                                      color={0,0,0}),
        Rectangle(
          extent={{-4,-168},{4,-210}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2,-204},{2,-208}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2,-172},{2,-176}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,-168},{16,-210}},
          lineColor={162,29,33},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-204},{14,-208}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-172},{14,-176}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-240},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
September 25, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>BAS Controller</h4>
<p>This controller combines the functions of the
supply fan controller
(<code>SupplyFanController</code>), exhaust fan controller 
(<code>ExhaustFanController</code>), temperature set point block 
(<code>TSupSet</code>), economizer mode block 
(<code>EconMode</code>), dehumidification mode block 
(<code>DehumMode</code>), dewpoint calculation block 
(<code>Dewpoint</code>), cooling coil 
(<code>CoolingCoil</code>), heating coil 
(<code>HeatingCoil</code>), and total energy wheel controller 
(<code>EnergyWheel</code>). 
</p>
</html>"),
    experiment(StopTime=10300, __Dymola_Algorithm="Dassl"));
end DOAScontroller;
