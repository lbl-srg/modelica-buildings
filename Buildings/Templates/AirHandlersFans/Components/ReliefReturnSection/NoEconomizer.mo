within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model NoEconomizer "No air economizer"
  extends
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoEconomizer,
    final typDamRel=damRel.typ,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=fanRet.typ);

  Buildings.Templates.Components.Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamRel_nominal,
    final text_flip=true)
    "Relief damper" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-150,0})));
  replaceable Buildings.Templates.Components.Fans.SingleVariable fanRet
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dpFan_nominal,
      final have_senFlo=
        typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Airflow,
      final text_flip=true)
    "Return fan"
    annotation (choices(choice(redeclare replaceable
      Buildings.Templates.Components.Fans.SingleVariable fanRet
      "Single fan - Variable speed"), choice(redeclare replaceable
      Buildings.Templates.Components.Fans.ArrayVariable fanRet
      "Multiple fans (identical) - Variable speed")),
      Placement(
    transformation(extent={{70,-10},{50,10}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure,
    final m_flow_nominal=m_flow_nominal) "Return static pressure sensor"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));

equation
  /* Control point connection - start */
  connect(fanRet.bus, bus.fanRet);
  connect(damRel.bus, bus.damRel);
  /* Control point connection - end */
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damRel.port_a, splEco.port_2)
    annotation (Line(points={{-140,0},{-10,0}}, color={0,127,255}));
  connect(fanRet.port_a, port_a)
    annotation (Line(points={{70,0},{180,0}}, color={0,127,255}));
  connect(splEco.port_1, fanRet.port_b)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
5.16.10 Return-Fan Control—Direct Building Pressure
5.16.10.1 Return fan operates whenever the associated
supply fan is proven ON and shall be off otherwise.
5.16.10.2 Return fans shall be controlled to maintain returnfan
discharge static pressure at set point (Section 5.16.10.5).
5.16.10.3 Exhaust dampers shall only be enabled when
the associated supply and return fans are proven ON and the
minimum outdoor air damper is open. The exhaust dampers
shall be closed when disabled.
5.16.10.5 When exhaust dampers are enabled, a control
loop shall modulate exhaust dampers in sequence with the
return-fan static pressure set point, as shown in Figure
5.16.10.5, to maintain the building pressure at a set point of
12 Pa (0.05 in. of water).
a. From 0% to 50%, the building pressure control loop shall
modulate the exhaust dampers from 0% to 100% open.
b. From 51% to 100%, the building pressure control loop
shall reset the return-fan discharge static pressure set point
from RFDSPmin at 50% loop output to RFDSPmax at
100% of loop output. See Section 3.2.1.4 for RFDSPmin
and RFDSPmax.
</p>
<p>
5.16.11 Return-Fan Control— Airflow Tracking
5.16.11.1 Return fan operates whenever associated supply
fan is proven ON.
5.16.11.2 Return-fan speed shall be controlled to maintain
return airflow equal to supply airflow less differential SR-
DIFF, as determined per Section 3.2.1.5.
5.16.11.3 Relief/exhaust dampers shall be enabled when
the associated supply and return fans are proven ON and
closed otherwise. Exhaust dampers shall modulate as the
inverse of the return air damper per Section 5.16.2.3.4.
</p>
</html>"), Icon(graphics={
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1)}));
end NoEconomizer;
