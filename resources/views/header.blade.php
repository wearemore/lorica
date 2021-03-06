<!DOCTYPE html>
<html {!! get_language_attributes() !!}>
<head>
  <meta charset="{{ get_bloginfo('charset') }}">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  @include('partials/favicons')

  <meta name="theme-color" content="#0072bc">

  <!-- Disable tap highlight on IE -->
  <meta name="msapplication-tap-highlight" content="no">

  @php wp_head() @endphp
</head>
<body @php body_class() @endphp>

         @include('partials/cookie-bar')
