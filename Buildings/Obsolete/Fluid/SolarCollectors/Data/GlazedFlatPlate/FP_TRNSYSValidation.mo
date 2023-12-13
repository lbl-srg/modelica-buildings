within Buildings.Fluid.Obsolete.SolarCollectors.Data.GlazedFlatPlate;
record FP_TRNSYSValidation =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=5,
    mDry=8.6,
    V=0.6/1000,
    dp_nominal=100,
    mperA_flow_nominal=0.0111,
    B0=-0.2,
    B1=-0,
    y_intercept=0.8,
    slope=-3.6111,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal=800,
    dT_nominal=10)
  "Default values in the TRNSYS Simulation Studio SDHW example"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
      <p>
        Default values in the TRNSYS Simualtion Studio SDHW example.
        No value for <code>dp_nominal</code> was provided in TRNSYS, so 100
        Pascal was used as a placeholder.<br/>
      </p>
    </html>"));
