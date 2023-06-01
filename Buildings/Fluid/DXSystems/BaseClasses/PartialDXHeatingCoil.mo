within Buildings.Fluid.DXSystems.BaseClasses;
partial model PartialDXHeatingCoil
  "Partial model for DX heating coil"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    final m_flow_nominal = datCoi.sta[nSta].nomVal.m_flow_nominal);

  parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.Coil datCoi
    "Performance data"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  parameter Modelica.Units.SI.TemperatureDifference dTHys(
    final min=0)=0.5
    "Temperature comparison for hysteresis"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Modelica.Blocks.Interfaces.RealInput phi(
    final unit="1")
    "Outdoor air relative humidity at evaporator inlet (0...1)" annotation (
      Placement(transformation(extent={{-120,60},{-100,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Fluid.DXSystems.BaseClasses.DryCoil dxCoi(
    final datCoi=datCoi,
    final variableSpeedCoil=false,
    final use_mCon_flow=false) "DX coil"
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));

protected
  constant String substanceName="water"
    "Name of species substance";

  parameter Integer nSta=datCoi.nSta "Number of stages";

  parameter Integer i_x(fixed=false)
    "Index of substance";

  parameter Modelica.Units.SI.AbsolutePressure pAtm(fixed=false)
    "Atmospheric pressure";

  Modelica.Units.SI.SpecificEnthalpy hIn=inStream(port_a.h_outflow)
    "Enthalpy of air entering the DX coil";

  Modelica.Units.SI.Temperature TIn=Medium.temperature_phX(
    p=port_a.p,
    h=hIn,
    X=XIn)
    "Dry bulb temperature of air entering the DX coil";

  Modelica.Units.SI.MassFraction XIn[Medium.nXi]=inStream(
    port_a.Xi_outflow)
    "Mass fraction/absolute humidity of air entering the DX coil";

  Modelica.Blocks.Sources.RealExpression T(
    final y=TIn)
    "Inlet air temperature"
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));

  Modelica.Blocks.Sources.RealExpression m(
    final y=port_a.m_flow) "Inlet air mass flow rate"
    annotation (Placement(transformation(extent={{-90,44},{-68,64}})));

  Buildings.Fluid.DXSystems.BaseClasses.CoilDefrostTimeCalculations
    defTimFra(
    final defTri=datCoi.defTri,
    final tDefRun=datCoi.tDefRun,
    final TDefLim=datCoi.TDefLim,
    final dTHys=dTHys)
    "Block to compute defrost time fraction, heat transfer multiplier and input power multiplier"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Fluid.DXSystems.BaseClasses.CoilDefrostCapacity defCap(
    redeclare package MediumA = Medium,
    final defTri=datCoi.defTri,
    final defOpe=datCoi.defOpe,
    final tDefRun=datCoi.tDefRun,
    final defCur=datCoi,
    final QDefResCap=datCoi.QDefResCap)
    "Block to compute actual heat transferred to medium and power input after accounting for defrost"
    annotation (Placement(transformation(extent={{62,76},{82,96}})));

  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(
    final use_p_in=false,
    final p=pAtm)
    "Conversion for relative humidity to water vapor mass fraction"
    annotation (Placement(transformation(extent={{-60,88},{-40,108}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow q
    "Heat extracted by coil"
    annotation (Placement(transformation(extent={{58,10},{38,30}})));

  Modelica.Blocks.Sources.RealExpression p_in(
    final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Modelica.Blocks.Sources.RealExpression X(
    final y=XIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));


initial algorithm
  // Make sure that |Q_flow_nominal[nSta]| >= |Q_flow_nominal[i]| for all stages because the data
  // of nSta are used in the evaporation model
  for i in 1:(nSta-1) loop
    assert(datCoi.sta[i].nomVal.Q_flow_nominal >= datCoi.sta[nSta].nomVal.Q_flow_nominal,
    "Error in DX coil performance data: Q_flow_nominal of the highest stage must have
    the biggest value in magnitude. Obtained " + Modelica.Math.Vectors.toString(
    {datCoi.sta[i].nomVal.Q_flow_nominal for i in 1:nSta}, "Q_flow_nominal"));
  end for;

  // Compute index of species vector that carries the substance name
  i_x :=-1;
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2=substanceName,
                                            caseSensitive=false) then
        i_x :=i;
      end if;
    end for;
  assert(i_x > 0, "Substance '" + substanceName + "' is not present in medium '"
                  + Medium.mediumName + "'.\n"
                  + "Change medium model to one that has '" + substanceName + "' as a substance.");

  pAtm :=port_a.p;
equation
  connect(m.y,dxCoi. m_flow) annotation (Line(
      points={{-66.9,54},{-66,54},{-66,54.4},{-21,54.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(q.port, vol.heatPort) annotation (Line(
      points={{38,20},{-20,20},{-20,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-26,62},{-26,52},{-21,52}},
                         color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-38,28},{-38,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut, defTimFra.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,
          62},{-26,62},{-26,102},{-1,102}},
                          color={0,0,127}));
  connect(defTimFra.tDefFra, defCap.tDefFra) annotation (Line(points={{21,104},{
          40,104},{40,97},{61,97}},        color={0,0,127}));
  connect(defTimFra.heaCapMul, defCap.heaCapMul) annotation (Line(points={{21,100},
          {34,100},{34,94},{61,94}},        color={0,0,127}));
  connect(defTimFra.inpPowMul, defCap.inpPowMul) annotation (Line(points={{21,96},
          {28,96},{28,91},{61,91}},         color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-38,28},{-38,88},
          {61,88}},  color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot_flow) annotation (Line(points={{1,56},{22,56},
          {22,72},{61,72}},       color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,75},
          {61,75}},       color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-26,62},{-26,78},{61,78}},
                     color={0,0,127}));
  connect(defCap.QTotDef_flow, q.Q_flow) annotation (Line(points={{83,78},{92,
          78},{92,20},{58,20}},                  color={0,0,127}));
  connect(defCap.QTotDef_flow, QSen_flow) annotation (Line(points={{83,78},{92,
          78},{92,70},{110,70}},  color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{83,90},{110,90}},
                color={0,0,127}));
  connect(p_in.y, defCap.pIn) annotation (Line(points={{-69,-20},{-30,-20},{-30,
          81},{61,81}},   color={0,0,127}));
  connect(X.y, defCap.XConIn) annotation (Line(points={{-69,12},{-34,12},{-34,84},
          {61,84}},       color={0,0,127}));
  connect(defTimFra.XOut, x_pTphi.X[1])
    annotation (Line(points={{-1,98},{-39,98}}, color={0,0,127}));
  connect(x_pTphi.T, TOut) annotation (Line(points={{-62,98},{-92,98},{-92,30},{
          -110,30}}, color={0,0,127}));
  connect(x_pTphi.phi, phi) annotation (Line(points={{-62,92},{-96,92},{-96,70},
          {-110,70}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed\">
Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 31, 2023, by Michael Wetter:<br/>
Changed implementation to use <code>phi</code> rather than water vapor concentration
as input because the latter is not available on the weather data bus.
</li>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={             Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen"),
                   Text(
          extent={{-136,98},{-78,80}},
          textColor={0,0,127},
          textString="phi"),
                   Text(
          extent={{-140,58},{-82,40}},
          textColor={0,0,127},
          textString="TOut")}),
    Diagram(coordinateSystem(extent={{-100,-60},{100,120}})));
end PartialDXHeatingCoil;
