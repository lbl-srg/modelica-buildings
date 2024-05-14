within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
partial model PartialOperationalEnvelope
  "Indicates if the device operation is within a defined envelope"
  extends BaseClasses.PartialSafetyWithCounter;
  parameter Modelica.Units.SI.Temperature tabUppHea[:,2]
    "Upper boundary for heating with second column as useful temperature side";
  parameter Modelica.Units.SI.Temperature tabLowCoo[:,2]
    "Lower boundary for cooling with second column as useful temperature side";
  parameter Boolean use_TConOutHea=true
    "=true to use condenser outlet temperature for envelope in heating mode, false for inlet"
    annotation (Dialog(group="Operational Envelope"));
  parameter Boolean use_TEvaOutHea=false
    "=true to use evaporator outlet temperature for envelope in heating mode, false for inlet"
    annotation (Dialog(group="Operational Envelope"));
  parameter Boolean use_TConOutCoo=false
    "=true to use useful side outlet temperature for envelope in cooling mode, false for inlet"
    annotation (Dialog(group="Operational Envelope"));
  parameter Boolean use_TEvaOutCoo=true
    "=true to use evaporator outlet temperature for envelope in cooling mode, false for inlet"
    annotation (Dialog(group="Operational Envelope"));

  parameter Modelica.Units.SI.TemperatureDifference dTHys=5
    "Temperature deadband in the operational envelope";

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.BoundaryMap bouMapHea(
    final tab=tabUppHea,
    final dT=dTHys,
    final isUppBou=true) "Operational boundary map for heating operation"
    annotation (Placement(transformation(extent={{-80,40},{-20,100}})));

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.BoundaryMap bouMapCoo(
    final tab=tabLowCoo,
    final dT=dTHys,
    final isUppBou=false) "Operational boundary map for cooling operation"
    annotation (Placement(transformation(extent={{-80,-80},{-20,-20}})));
  Modelica.Blocks.Logical.LogicalSwitch swiHeaCoo
    "Switch between heating and cooling envelope"
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,0},{-80,0},{-80,20},{
          70,20},{70,8},{78,8}},
                  color={0,0,127}));
  connect(swiHeaCoo.y, booPasThr.u)
    annotation (Line(points={{17,0},{38,0}}, color={255,0,255}));
  connect(bouMapCoo.noErr, swiHeaCoo.u3)
    annotation (Line(points={{-17,-50},{-12,-50},{-12,-8},{-6,-8}},
                                                          color={255,0,255}));
  connect(bouMapHea.noErr, swiHeaCoo.u1)
    annotation (Line(points={{-17,70},{-12,70},{-12,8},{-6,8}},
                                                       color={255,0,255}));

  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model to check if the operating conditions are inside
  the given boundaries. If not, the heat pump or chiller will switch off.
</p>
<p>
  This safety control is mainly based on the operational
  envelope of the compressor.
  Refrigerant flowsheet and type will influence these values.
</p>
<h4>Limitations</h4>

<ul>
<li>
  Only three sides of the real envelope are implemented (Figures 2 and 3).
  The real operational envelope implies continuous operation.
  This means start-up from e.g. a cold heat pump supply temperature
  is possible. To avoid additional equations for startup and
  continuous operation, we neither implement the
  lower boundary for heating nor the upper boundary for cooling devices.
  This avoids the situation where the device can never be turned on.
</li>
<li>
  From all the influences on the real envelope, the compressor frequency
  impacts the possible range of operation. However, the compressor
  speed-dependent envelopes are typcially not provided in datasheets.
  Further, including a third dimension requires 3D-table data. This is
  currently not supported by Buildings or Modelica Standard Library.
</li>
</ul>

<h4>Existing envelopes</h4>
<p>
  Technical datasheets often contain
  information about the operational envelope.
  The device records for heat pumps
  (<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DData</a>)
  and chillers
  (<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D\">
  Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2DData</a>)
  contain typical values. Older devices typically have lower limits
  while new refrigerant machines based on propane or advanced flowsheets
  are able to achieve temperature over 70 °C for heating.
</p>
<h4>Parameterization from datasheets</h4>
<p>
  Depending on the underlying datasheet in use, you have to think
  thoroughly if you need inlet or outlet conditions, and if
  you are modelling a heat pump or chiller.
  Figure 1 depicts possible upper and lower boundaries as well as
  what variables the boundaries are defined with.
  Depending on your setup, you may have to transpose existing boundaries.
  For instance, when using an envelope designed for a
  heat pump in a chiller model, the useful side (column 2 of the data)
  is not the condenser but the evaporator. Thus, you have to
  switch columns 1 and 2.
  The following examples aim to explain how to obtain the envelopes:
</p>
<p>
  If the model in use is a heat pump,
  the useful side is always the side of
  <code>TConOutMea</code> and <code>TConInMea</code>.
  In the chiller, the useful side is always the side of
  <code>TEvaOutMea</code> or <code>TEvaInMea</code>.
</p>
<ol>
<li>
  The envelopes for air-to-water heat pumps
  often contain water supply temperature (<code>TConOutMea</code>)
  on the y-axis and ambient temperatures (<code>TEvaInMea</code>)
  on the x-axis. In these cases, <code>tabUppHea</code> is based
  on the y-axis maximal values and <code>tabLowCoo</code>
  based on the y-axis minimal values.
  Figure 2 depicts this setup.
</li>
<li>
  The envelopes for air-to-air devices often
  contain ambient inlet (<code>TConInMea</code>) as y and
  room (<code>TEvaInMea</code>) inlet temperatures as x.
  In these cases, <code>tabUppHea</code> is based on the x-axis maximal
  values and tabLowCoo based on the x-axis minimal values.
  Figure 3 depicts this setup.
</li>
<li>
  Compressor datasheets often provide evaporating and condensing
  temperatures or pressure levels. Those are not avaiable in the
  simpified model approach. Thus, you have to assume pinch
  temperatures to convert it to either in- or outflow temperature
  levels of the secondary side temperatures
  (i.e. <code>TConOutMea</code>, <code>TConInMea</code>,
  <code>TEvaInMea</code>, <code>TEvaOutMea</code>).
</li>
</ol>

<p align=\"center\">
<img  style=\"width: 500\" alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/ModularReversible/Controls/SafetyControls/OperationalEnvelope_1.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 1: Possible upper and lower boundaries
  as well as temperature specifications in datasheets
</p>

<p align=\"center\">
<img  style=\"width: 500\" alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/ModularReversible/Controls/SafetyControls/OperationalEnvelope_2.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 2: Example for an air-to-water heat pump or chiller.
  The supply temperature is the temperature leaving the device
  into the hydraulic circuit of the building.
  Red crosses indicate the point to write into the 2D table in Modelica.
</p>

<p align=\"center\">
<img  style=\"width: 500\" alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/ModularReversible/Controls/SafetyControls/OperationalEnvelope_3.png\" border=\"1\"/>
</p>
<p align=\"center\">
  Figure 3: Example for an air-to-air heat pump or chiller.
  The room temperature acts as an inflow to the device.
  Red crosses indicate the point to write into the 2D table in Modelica.
</p>

</html>"));
end PartialOperationalEnvelope;
