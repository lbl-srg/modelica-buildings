within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXCoil
  "Partial model for air or water cooled DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialCoolingParameters;
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    final m_flow_nominal = datCoi.sta[nSta].nomVal.m_flow_nominal);

  constant Boolean use_mCon_flow
    "Set to true to enable connector for the condenser mass flow rate";

  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Moisture balance"));


  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Modelica.Blocks.Interfaces.RealInput mCon_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") if use_mCon_flow
    "Water mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  replaceable Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface dxCoi
    constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilInterface(
    datCoi=datCoi,
    final use_mCon_flow=use_mCon_flow)
    "DX coil"
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));

protected
  constant String substanceName="water"
    "Name of species substance";
  parameter Integer i_x(fixed=false)
    "Index of substance";

  // Flow reversal is not needed. Also, if ff < ffMin/4, then
  // Q_flow and EIR are set the zero. Hence, it is safe to assume
  // forward flow, which will avoid an event

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

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Temperature of the control volume"
    annotation (Placement(transformation(extent={{66,16},{78,28}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow q
    "Heat extracted by coil"
    annotation (Placement(transformation(extent={{42,44},{62,64}})));

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

  connect(mCon_flow, dxCoi.mCon_flow) annotation (Line(points={{-110,-30},{-24,
          -30},{-24,42},{-21,42}}, color={0,0,127}));

  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoolingCoil</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXHeatingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXHeatingCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Changed baseclass to create common version for both heating and cooling coils.<br/>
Renamed <code>TConIn</code> to <code>TOut</code>.<br/>
Moved instances <code>QLat_flow</code> and <code>eva</code> to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoolingCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoolingCoil</a>.
</li>
<li>
June 19, 2017, by Michael Wetter:<br/>
Added missing <code>replaceable</code> to the medium declaration.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/810\">Buildings #810</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
February 27, 2017 by Yangyang Fu:<br/>
Added <code>redeclare</code> for the type of <code>cooCap</code> in <code>dxCoiOpe</code>.
</li>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol</code>.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Updated model due to change in
<code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>.
</li>
<li>
September 24, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Moved assignments to declaration section to avoid mixing graphical modeling with textual
modeling in <code>equation</code> section.
Redeclare medium model as <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
to remove errors during model check.
Added output connectors for sensible and latent heat flow rate.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={             Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),
          Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen"),
                   Text(
          extent={{-158,56},{-100,38}},
          textColor={0,0,127},
          textString="TOut"),
                   Text(
          extent={{-158,-2},{-100,-20}},
          textColor={0,0,127},
          textString="mCon_flow",
          visible = use_mCon_flow)}));
end PartialDXCoil;
