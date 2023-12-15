package wazevo_test

import (
	"context"
	"github.com/evacchi/wazero-bench/require"
	"github.com/tetratelabs/wazero"
	"github.com/tetratelabs/wazero/experimental/opt"
	"github.com/tetratelabs/wazero/imports/wasi_snapshot_preview1"
	"os"
	"testing"
)

var configs = []struct {
	name   string
	config wazero.RuntimeConfig
}{
	{
		name:   "baseline",
		config: wazero.NewRuntimeConfigCompiler(),
	},
	{
		name:   "optimizing",
		config: opt.NewRuntimeConfigOptimizingCompiler(),
	},
}

func BenchmarkZig(b *testing.B) {
	dir := "testdata/zig/"
	ctx := context.Background()

	modCfg := wazero.NewModuleConfig().
		WithFSConfig(wazero.NewFSConfig().WithDirMount(".", "/")).
		WithArgs("test.wasm")

	files, err := os.ReadDir(dir)
	require.NoError(b, err)
	for _, f := range files {
		bin, err := os.ReadFile(dir + f.Name())
		require.NoError(b, err)
		b.Run(f.Name(), func(b *testing.B) {
			for _, cfg := range configs {
				r := wazero.NewRuntimeWithConfig(ctx, cfg.config)
				wasi_snapshot_preview1.MustInstantiate(ctx, r)
				b.Cleanup(func() { r.Close(ctx) })

				m, err := r.CompileModule(ctx, bin)
				require.NoError(b, err)

				b.Run(cfg.name, func(b *testing.B) {
					b.Run("Compile", func(b *testing.B) {
						_, err := r.CompileModule(ctx, bin)
						require.NoError(b, err)
					})
					b.Run("Run", func(b *testing.B) {
						_, err = r.InstantiateModule(ctx, m, modCfg)
						require.NoError(b, err)
					})
				})
			}
		})
	}
}
