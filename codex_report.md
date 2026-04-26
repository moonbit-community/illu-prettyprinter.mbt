# Dependency Check Report

`moon check` fails while compiling dependency `illusory0x0/immut_deque`.

I ran:

- `moon check`
- `moon add illusory0x0/immut_deque`
- `moon check`

`moon add illusory0x0/immut_deque` completed successfully but did not resolve the dependency error. The dependency remains pinned as `illusory0x0/immut_deque@0.3.4`.

The failing files are under `.mooncakes/illusory0x0/immut_deque/src/`, including:

- `deque.mbt`
- `list.mbt`
- `tsil.mbt`

Main error categories:

- `Type T[A] has no method inner.`
- `Type List[A] has no method inner.`
- `Type Tsil[A] has no method inner.`
- `Iter::new` is called with a callback taking one argument, but the current API expects `() -> A?`.
- `A?` does not have constructor `IterEnd`.
- `List[A]` / `Tsil[A]` do not implement `Add` for the current `+` usages.

Because the errors originate from the dependency cache rather than this repository's source files, I stopped before attempting repository-local fixes.
