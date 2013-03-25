within Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate;
record TRNSYSValidation =
    Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.GenericGlazedFlatPlate
    (
    ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
    A=5,
    mDry=8.6,
    V=0.6/1000,
    dp_nominal=1103*1000,
    VperA_flow_nominal=11.1/(10^6),
    B0=-0.2,
    B1=-0,
    y_intercept = 0.8,
    slope= - 3.6111,
    IAMDiff = 0,
    C1 = 0,
    C2 = 0) "Water-based, ACR Solar International: Skyline 10-01";
