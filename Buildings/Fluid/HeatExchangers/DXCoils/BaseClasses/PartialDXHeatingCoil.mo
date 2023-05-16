within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil
  "Partial model for DX heating coil"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    final m_flow_nominal = datCoi.sta[nSta].nomVal.m_flow_nominal);

  parameter Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Data.Generic.Coil datCoi
    "Performance data"
    annotation (Placement(transformation(extent={{-80,82},{-68,94}})));

  parameter Modelica.Units.SI.TemperatureDifference dTHys(
    final min=0)=0.5
    "Temperature comparison for hysteresis"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final displayUnit="kg/kg",
    final quantity="MassFraction")
    "Outside air humidity ratio per kg of total air"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
      iconTransformation(extent={{-120,60},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

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

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
    final datCoi=datCoi,
    final variableSpeedCoil=false,
    final use_mCon_flow=false) "DX coil"
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));

  // Flow reversal is not needed. Also, if ff < ffMin/4, then
  // Q_flow and EIR are set the zero. Hence, it is safe to assume
  // forward flow, which will avoid an event

//  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
//    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
//      redeclare package Medium = Medium,
//      redeclare Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Data.Generic.Coil datCoi),
//    redeclare Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Data.Generic.Coil datCoi);

protected
  constant String substanceName="water"
    "Name of species substance";

  parameter Integer nSta=datCoi.nSta "Number of stages";

  parameter Integer i_x(fixed=false)
    "Index of substance";
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
    annotation (Placement(transformation(extent={{-90,34},{-70,54}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations
    defTimFra(
    final defTri=datCoi.defTri,
    final tDefRun=datCoi.tDefRun,
    final TDefLim=datCoi.TDefLim,
    final dTHys=dTHys)
    "Block to compute defrost time fraction, heat transfer multiplier and input power multiplier"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostCapacity defCap(
    redeclare package MediumA = Medium,
    final defTri=datCoi.defTri,
    final defOpe=datCoi.defOpe,
    final tDefRun=datCoi.tDefRun,
    final defCur=datCoi,
    final QDefResCap=datCoi.QDefResCap)
    "Block to compute actual heat transferred to medium and power input after accounting for defrost"
    annotation (Placement(transformation(extent={{62,76},{82,96}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Temperature of the control volume"
    annotation (Placement(transformation(extent={{66,16},{78,28}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow q
    "Heat extracted by coil"
    annotation (Placement(transformation(extent={{42,44},{62,64}})));

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

equation
  connect(m.y,dxCoi. m_flow) annotation (Line(
      points={{-69,44},{-66,44},{-66,54.4},{-21,54.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(q.port, vol.heatPort) annotation (Line(
      points={{62,54},{66,54},{66,22},{-12,22},{-12,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TVol.port, q.port) annotation (Line(
      points={{66,22},{66,54},{62,54}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-46,62},{-46,52},{-21,52}},
                         color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-40,28},{-40,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut, defTimFra.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,
          62},{-46,62},{-46,102},{-1,102}},
                          color={0,0,127}));
  connect(defTimFra.tDefFra, defCap.tDefFra) annotation (Line(points={{21,104},{
          40,104},{40,97},{61,97}},        color={0,0,127}));
  connect(defTimFra.heaCapMul, defCap.heaCapMul) annotation (Line(points={{21,100},
          {34,100},{34,94},{61,94}},        color={0,0,127}));
  connect(defTimFra.inpPowMul, defCap.inpPowMul) annotation (Line(points={{21,96},
          {28,96},{28,91},{61,91}},         color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-40,28},{-40,88},
          {61,88}},  color={0,0,127}));
  connect(XOut, defTimFra.XOut) annotation (Line(points={{-110,70},{-52,70},{-52,
          98},{-1,98}},   color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot_flow) annotation (Line(points={{1,56},{22,56},
          {22,72},{61,72}},       color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,75},
          {61,75}},       color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-46,62},{-46,78},{61,78}},
                     color={0,0,127}));
  connect(defCap.QTotDef_flow, q.Q_flow) annotation (Line(points={{83,78},{94,78},
          {94,10},{32,10},{32,54},{42,54}},      color={0,0,127}));
  connect(defCap.QTotDef_flow, QSen_flow) annotation (Line(points={{83,78},{98,78},
          {98,70},{110,70}},      color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{83,90},{110,90}},
                color={0,0,127}));
  connect(p_in.y, defCap.pIn) annotation (Line(points={{-69,-20},{-30,-20},{-30,
          81},{61,81}},   color={0,0,127}));
  connect(X.y, defCap.XConIn) annotation (Line(points={{-69,12},{-36,12},{-36,84},
          {61,84}},       color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.SingleSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
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
          extent={{-158,98},{-100,80}},
          textColor={0,0,127},
          textString="XOut")}),
    Diagram(coordinateSystem(extent={{-100,-60},{100,120}})));
end PartialDXHeatingCoil;
