within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithPump "Heat exchanger with pump for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump,
    hex(from_dp2=true));

  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mChiWat_flow_nominal,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "WSE entering CHW temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,20})));
  Buildings.Templates.Components.Pumps.Single pumChiWatEco(
    have_valChe=false,
    redeclare final package Medium = MediumChiWat,
    final have_var=true,
    final dat=datPumChiWat,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchanger CHW pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,50})));
  Fluid.FixedResistances.PressureDrop resChiWatByp(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    from_dp=true,
    final dp_nominal=100)
    "Bypass flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  /* Control point connection - start */
  connect(bus.pumChiWatEco, pumChiWatEco.bus);
  connect(bus.TChiWatEcoEnt, TChiWatEcoEnt.y);
  /* Control point connection - stop */
  connect(TChiWatEcoEnt.port_b, pumChiWatEco.port_a)
    annotation (Line(points={{-20,30},{-20,40}}, color={0,127,255}));
  connect(pumChiWatEco.port_b, hex.port_a2)
    annotation (Line(points={{-20,60},{-20,68},{-10,68}}, color={0,127,255}));
  connect(port_a, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-100,0},{-20,0},{-20,10}}, color={0,127,255}));
  connect(port_a, resChiWatByp.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(resChiWatByp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
annotation (
 defaultComponentName="eco",
Documentation(info="<html>
<p>
This is a model of a waterside economizer where a variable speed
pump is used to control the CHW flow rate
through the heat exchanger.
The CW flow rate is modulated by means of a two-way valve.
As per standard practice, the model includes a temperature
sensor on the CHW side, upstream of the heat exchanger.
This sensor is typically used in conjunction with a temperature
sensor in the CHW return pipe, upstream of the WSE, to reset
the pump speed and avoid flow recirculation through the heat
exchanger.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
    Bitmap(
      extent={{300,-320},{380,-240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
    Bitmap(extent={{240,-40},{440,-240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg"),
    Line(points={{216,-142},{216,-180}},color={0,0,0}),
    Bitmap(
        extent={{158,-280},{258,-180}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Bitmap(
          extent={{258,-150},{158,-50}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg")}));
end HeatExchangerWithPump;
