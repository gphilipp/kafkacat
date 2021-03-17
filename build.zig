const Builder = @import("std").build.Builder;




pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();


    const json = b.addStaticLibrary("json", null);
    json.setTarget(target);
    json.setBuildMode(mode);
    json.linkLibC();
    json.addCSourceFiles(&.{
         "json.c"
     },&.{});


    const avro = b.addStaticLibrary("avro", null);
    avro.setTarget(target);
    avro.setBuildMode(mode);
    avro.linkLibC();
    avro.addCSourceFiles(&.{
         "avro.c"
     },&.{});

    const libserdes = b.addStaticLibrary("libserdes", null);
    libserdes.setTarget(target);
    libserdes.setBuildMode(mode);
    libserdes.linkLibC();
    libserdes.addIncludeDir("deps/avro/lang/c/src");
    libserdes.addCSourceFiles(&.{
         "deps/libserdes/src/serdes.c"
     },&.{});


    const librdkafka = b.addStaticLibrary("librdkafka", null);
    librdkafka.setTarget(target);
    librdkafka.setBuildMode(mode);
    librdkafka.linkLibC();
    librdkafka.addCSourceFiles(&.{
         //"deps/librdkafka/src/crc32c.c"
         "librdkafka/src/rdkafka.c"
     },&.{});


    const kafkacat = b.addExecutable("kafkacat", null);
    kafkacat.setTarget(target);
    kafkacat.setBuildMode(mode);
    kafkacat.install();
    kafkacat.linkLibrary(librdkafka);
    kafkacat.linkLibrary(libserdes);
    kafkacat.addIncludeDir("librdkafka/src");
    kafkacat.addCSourceFiles(&.{
         "kafkacat.c",
         "avro.c"
     },&.{});

    //kafkacat.install();

    const run_cmd = kafkacat.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
