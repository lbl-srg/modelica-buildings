within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialHVAC
  "Partial model of variable air volume flow system with terminal reheat that serves five thermal zones"

  extends Buildings.Examples.VAVReheat.BaseClasses.HVAC_Interface;

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    Q_flow_nominal=QHeaAHU_flow_nominal,
    m1_flow_nominal=mHeaWat_flow_nominal,
    m2_flow_nominal=mHeaAir_flow_nominal,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=3000,
    dp2_nominal=0,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THeaWatInl_nominal,
    T_a2_nominal=THeaAirMix_nominal)
    "Heating coil"
    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

  Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QCooAHU_flow_nominal,
    m1_flow_nominal=mCooWat_flow_nominal,
    m2_flow_nominal=mCooAir_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=3000,
    T_a1_nominal=TCooWatInl_nominal,
    T_a2_nominal=TCooAirMix_nominal,
    w_a2_nominal=wCooAirMix_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    show_T=true) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PPum=pumHeaCoi.P + pumCooCoi.P,
    PHea=heaCoi.Q2_flow + sum(VAVBox.terHea.Q2_flow),
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";

  Fluid.FixedResistances.Junction splCooSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={220,-170})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valCooCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for cooling coil"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,-210})));
  Fluid.FixedResistances.Junction splCooRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-170})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumCooCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal,
    dp_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-120})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumHeaCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for heating coil" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-120})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage valHeaCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for heating coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={128,-210})));
  Fluid.FixedResistances.Junction splHeaRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,-170})));
  Fluid.FixedResistances.Junction splHeaSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-170})));


  Modelica.Fluid.Interfaces.FluidPort_a portHeaCoiSup(redeclare package Medium =
        MediumW) "Heating coil loop supply"
    annotation (Placement(transformation(extent={{70,-310},{90,-290}}),
        iconTransformation(extent={{-30,-150},{-10,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaCoiRet(redeclare package Medium =
        MediumW) "Heating coil loop return" annotation (Placement(
        transformation(extent={{110,-310},{130,-290}}),
                                                      iconTransformation(extent={{30,-150},
            {50,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiSup(redeclare package Medium =
        MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-310},{210,-290}}),
        iconTransformation(extent={{110,-150},{130,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiRet(redeclare package Medium =
        MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{230,-310},{250,-290}}),
        iconTransformation(extent={{170,-150},{190,-130}})));

protected
  constant Modelica.Units.SI.SpecificHeatCapacity cpAir=Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.Units.SI.SpecificHeatCapacity cpWat=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
  model Results "Model to store the results of the simulation"
    parameter Modelica.Units.SI.Area A "Floor area";
    input Modelica.Units.SI.Power PFan "Fan energy";
    input Modelica.Units.SI.Power PPum "Pump energy";
    input Modelica.Units.SI.Power PHea "Heating energy";
    input Modelica.Units.SI.Power PCooSen "Sensible cooling energy";
    input Modelica.Units.SI.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EPum(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Pump energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EPum) = PPum;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
equation


  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(
      points={{118,-40},{190,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(pumHeaCoi.port_b, heaCoi.port_a1) annotation (Line(points={{128,-110},
          {128,-52},{118,-52}}, color={0,127,255}));
  connect(cooCoi.port_b1,pumCooCoi. port_a) annotation (Line(points={{190,-52},{
          180,-52},{180,-110}}, color={0,127,255}));
  connect(splCooSup.port_2, cooCoi.port_a1) annotation (Line(points={{220,-160},
          {220,-52},{210,-52}}, color={0,127,255}));
  connect(splCooRet.port_3,splCooSup. port_3)
    annotation (Line(points={{190,-170},{210,-170}}, color={0,127,255}));
  connect(pumCooCoi.port_b, splCooRet.port_2)
    annotation (Line(points={{180,-130},{180,-160}}, color={0,127,255}));
  connect(splHeaSup.port_2, pumHeaCoi.port_a)
    annotation (Line(points={{128,-160},{128,-130}}, color={0,127,255}));
  connect(heaCoi.port_b1, splHeaRet.port_2)
    annotation (Line(points={{98,-52},{88,-52},{88,-160}}, color={0,127,255}));
  connect(splHeaRet.port_3, splHeaSup.port_3)
    annotation (Line(points={{98,-170},{118,-170}}, color={0,127,255}));
  connect(splHeaSup.port_1, valHeaCoi.port_b)
    annotation (Line(points={{128,-180},{128,-200}}, color={0,127,255}));
  connect(splCooSup.port_1, valCooCoi.port_b)
    annotation (Line(points={{220,-180},{220,-200}}, color={0,127,255}));
  connect(portHeaCoiSup, valHeaCoi.port_a) annotation (Line(points={{80,-300},{80,
          -262},{128,-262},{128,-220}},    color={0,127,255}));
  connect(portHeaCoiRet, splHeaRet.port_1) annotation (Line(points={{120,-300},
          {120,-240},{88,-240},{88,-180}}, color={0,127,255}));
  connect(portCooCoiSup, valCooCoi.port_a) annotation (Line(points={{200,-300},
          {200,-260},{220,-260},{220,-220}}, color={0,127,255}));
  connect(portCooCoiRet, splCooRet.port_1) annotation (Line(points={{240,-300},
          {240,-240},{180,-240},{180,-180}}, color={0,127,255}));

  for i in 1:numZon loop
  end for;

  for i in 1:(numZon - 2) loop
  end for;

  connect(cooCoi.port_b2, dpSupDuc.port_a)
    annotation (Line(points={{210,-40},{250,-40}}, color={0,127,255}));
  connect(TMix.port_b, heaCoi.port_a2)
    annotation (Line(points={{50,-40},{98,-40}}, color={0,127,255}));
  annotation (
  Diagram(
    coordinateSystem(
    preserveAspectRatio=false,
    extent={{-380,-300},{1420,360}})),
    Documentation(info="<html>
<p>
This partial model consist of an HVAC system that serves multiple thermal zones.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the zone inlet branches.
The figure below shows the schematic diagram of an HVAC system that supplies 5 zones:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
The control sequences for this HVAC system are added in
the two models that extend this model, namely
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 7, 2023, by Jianjun Hu:<br/>
Set the value of parameter <code>transferHeat</code> to <code>true</code> for the mixed air temperature sensor.
</li>
<li>
February 6, 2023, by Jianjun Hu:<br/>
Added junction to mix the return and outdoor air.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3230\">issue #3230</a>.
</li>
<li>
August 22, 2022, by Hongxiang Fu:<br/>
Replaced fan and pump models with preconfigured mover models.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue #2668</a>.
</li>
<li>
April 26, 2022, by Michael Wetter:<br/>
Changed fan efficiency calculation to use Euler number.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
November 9, 2021, by Baptiste Ravache:<br/>
Vectorized the terminal boxes to be expanded to any number of zones.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2735\">issue #2735</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for all mixing box dampers.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 11, 2021, by Michael Wetter:<br/>
Set parameter in weather data reader to avoid computation of wet bulb temperature which is need needed for this model.
</li>
<li>
February 03, 2021, by Baptiste Ravache:<br/>
Refactored the sizing of the heating coil in the <code>VAVBranch</code> (renamed <code>VAVReheatBox</code>) class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added design parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
<li>
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-200,-140},{440,220}}),graphics={
        Text(
          extent={{56,226},{168,290}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-200,222},{440,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialHVAC;
