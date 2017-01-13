///////////////////////////////////////////////////////////////////////////////
//
// Module      :  Lazy.hh
// Copyright   :  (c) Andy Arvanitis 2016
// License     :  MIT
//
// Maintainer  :  Andy Arvanitis <andy.arvanitis@gmail.com>
// Stability   :  experimental
// Portability :
//
// Lazy FFI functions
//
///////////////////////////////////////////////////////////////////////////////
//
#ifndef LazyFFI_HH
#define LazyFFI_HH

#include "PureScript/PureScript.hh"

namespace Data_Lazy {

  using namespace PureScript;

  // foreign import defer :: forall a. (Unit -> a) -> Lazy a
  //
  auto defer(const any& f) -> any;

  // foreign import force :: forall a. Lazy a -> a
  //
  auto force(const any& l) -> any;
}

#endif // LazyFFI_HH
