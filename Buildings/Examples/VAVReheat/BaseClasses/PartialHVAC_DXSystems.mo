within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialHVAC_DXSystems
  "Partial model of variable air volume flow system with terminal reheat that serves five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.HVAC_Interface(amb(nPorts=3));

  parameter Modelica.Units.SI.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";

  parameter Modelica.Units.SI.PressureDifference dpDisRetMax(displayUnit="Pa")=40
    "Maximum return fan discharge static pressure setpoint";

  parameter Modelica.Units.SI.PressureDifference dpAuxHea_nominal(displayUnit="Pa")=40
    "Maximum return fan discharge static pressure setpoint";

  parameter Integer nCoiCoo(min=1) = 3
    "Number of DX cooling coils"
    annotation (Dialog(group="Parameters"));

  parameter Integer nCoiHea(min=1) = 3
    "Number of DX heating coils"
    annotation (Dialog(group="Parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QAuxHea_flow_nominal=50000
    "Nominal heat flow rate of auxiliary heating coil"
    annotation (Dialog(group="Nominal heat flow rate"));

  replaceable parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datHeaCoi
    "Performance data of DX heating coil"
    annotation (Placement(transformation(extent={{84,-258},{104,-238}})));

  replaceable parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datCooCoi
    "Performance data of DX cooling coil"
    annotation (Placement(transformation(extent={{130,-258},{150,-238}})));

  replaceable Buildings.Examples.VAVReheat.BaseClasses.ParallelDXCoilHea ParDXCoiHea(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final show_T=true,
    final nCoiHea=nCoiHea,
    final datHeaCoi=datHeaCoi)
    "Parallel DX heating coil"
    annotation (Placement(transformation(extent={{100,-30},{120,-50}})));

  replaceable Buildings.Examples.VAVReheat.BaseClasses.ParallelDXCoilCoo ParDXCoiCoo(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final nCoiCoo=nCoiCoo,
    final minSpeRat=datCooCoi.minSpeRat,
    final datCooCoi=datCooCoi)
    "Parallel DX cooling coil"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u AuxHeaCoi(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAuxHea_nominal,
    final Q_flow_nominal=QAuxHea_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Auxiliary heating coil"
    annotation (Placement(transformation(extent={{214,-50},{234,-30}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0))
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));

  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
      iconTransformation(extent={{-168,134},{-148,154}})));

  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi
    "Calculate humidity ratio from outdoor air temperature and relative humidity"
    annotation (Placement(transformation(extent={{-300,90},{-280,110}})));

  Modelica.Blocks.Routing.RealPassThrough Phi(y(
    final unit="1"))
    "Outdoor air relative humidity"
    annotation (Placement(transformation(extent={{-300,130},{-280,150}})));

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
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-319.95,180.05},{-310,180.05},{-310,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(weaBus.pAtm, x_pTphi.p_in) annotation (Line(
      points={{-319.95,180.05},{-319.95,106},{-302,106}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, x_pTphi.T) annotation (Line(
      points={{-319.95,180.05},{-319.95,100},{-302,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, x_pTphi.phi) annotation (Line(
      points={{-319.95,180.05},{-319.95,94},{-302,94}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, Phi.u) annotation (Line(
      points={{-319.95,180.05},{-319.95,140},{-302,140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ParDXCoiHea.port_b, ParDXCoiCoo.port_a)
    annotation (Line(points={{120,-40},{180,-40}}, color={0,127,255}));

  connect(ParDXCoiCoo.port_b, AuxHeaCoi.port_a)
    annotation (Line(points={{200,-40},{214,-40}}, color={0,127,255}));

  connect(ParDXCoiHea.port_a, TMix.port_b)
    annotation (Line(points={{100,-40},{50,-40}}, color={0,127,255}));

  connect(TRet.port_b, amb.ports[3]) annotation (Line(points={{90,140},{-106,140},
          {-106,-45},{-114,-45}}, color={0,127,255}));

  connect(AuxHeaCoi.port_b, dpSupDuc.port_a)
    annotation (Line(points={{234,-40},{250,-40}}, color={0,127,255}));

  annotation (Diagram(
    coordinateSystem(
    preserveAspectRatio=false,
    extent={{-380,-300},{1420,360}})),
    Documentation(info="<html>
  <p>
  This partial model consist of an HVAC system that serves multiple thermal zones. 
  </p>
  <p>
  The HVAC system is a variable air volume (VAV) flow system with economizer
  and a direct expansion (DX) heating and cooling coil in the rooftop unit (RTU). 
  There is also a reheat coil and an air damper in each of the zone inlet branches.
  The figure below shows the schematic diagram of an HVAC system that supplies 5 zones:
  </p>
  <p align=\"center\">
  <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/rtuSchematics.png\" border=\"1\"/>
  </p>
  <p>
  The control sequences for this HVAC system are added in
  the model that extends this model, namely
  <a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36_DXSystems\">
  Buildings.Examples.VAVReheat.Guideline36_DXSystems</a>.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  February 15, 2024, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
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
end PartialHVAC_DXSystems;
