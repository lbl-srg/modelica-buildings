within Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.Examples;
model BuildingTimeSeriesHeatingTableRead
  "Example model for the 1st generation building time series model. Heating load table is an external read-in file."
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";

  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";

  // Heating load
  parameter Modelica.SIunits.Power Q_flow_nominal= 19347.2793
    "Nominal heat flow rate";

  Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
    bld(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    tableOnFile=true,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte,
    tableName="HeatingLoadProfiles",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
    columns={2},
    timeScale=1) "Building model, heating only"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Fluid.Sources.Boundary_pT           souSte(
    redeclare package Medium = MediumSte,
    p(displayUnit="Pa") = pSte,
    T=TSte,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{80,-6},{60,14}})));
  Fluid.Sources.Boundary_pT           watSin(redeclare package Medium =
        MediumWat,
    p=pSte,        nPorts=1)
              "Water sink"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
equation
  connect(souSte.ports[1], bld.port_a)
    annotation (Line(points={{60,4},{-40,4}}, color={0,127,255}));
  connect(bld.port_b, watSin.ports[1]) annotation (Line(points={{-40,10},{0,10},
          {0,30},{40,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=31536000),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Examples/Heating/Generation1/BaseClasses/Examples/BuildingTimeSeriesHeatingTableRead.mos"
        "Simulate and plot"));
end BuildingTimeSeriesHeatingTableRead;
