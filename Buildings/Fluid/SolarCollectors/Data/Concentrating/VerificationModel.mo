within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record VerificationModel =
  SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Aperture,
    A=4.302,
    V=4.4/1000,
    dp_nominal = 1000,
    mperA_flow_nominal=0.0241,
    y_intercept=0.720,
    IAMDiff=0.133,
    C1=2.8312,
    C2=0.00119,
    B0=0,
    B1=0,
    mDry=484,
    slope=0,
    G_nominal = 1000,
    dT_nominal = 20) "All inputs necessary for verification of EN12975 models"
    annotation(Documentation(info = "<html>
    <p>
    No model tested to EN12975 standards provides all of the necessary information 
    for modeling. Specific limitations are dp_nominal, G_nominal and dT_nominal. This
    data record was created to allow verification of EN12975 base classes despite the
    limitations in available data.
    </p>
    </html>"));
