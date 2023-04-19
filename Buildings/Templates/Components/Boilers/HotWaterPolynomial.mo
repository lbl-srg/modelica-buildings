within Buildings.Templates.Components.Boilers;
model HotWaterPolynomial "Hot water boiler"
  extends Buildings.Templates.Components.Interfaces.BoilerHotWater(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial,
    redeclare Buildings.Fluid.Boilers.BoilerPolynomial boi(
      final Q_flow_nominal = dat.cap_nominal,
      final m_flow_nominal=dat.mHeaWat_flow_nominal,
      final dp_nominal=dat.dpHeaWat_nominal,
      final fue=dat.fue));

  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HotWaterPolynomial;
