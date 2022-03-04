within Buildings.Templates.AirHandlersFans.Validation;
model FanRelief
  extends BaseNoEconomizer(
    datTop(VAV_1(fanRel(m_flow_nominal=1))),
    redeclare UserProject.AHUs.FanRelief VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanRelief;
